# Video Diagnosis Report — NEXORA Flutter Web

**Date:** 2026-10-19  
**Site:** https://nexora-web-731248589799.web.app/  
**Video asset:** `assets/videos/120172-720504774.mp4`

---

## Summary (Root Cause)

**The mobile video fails because `HtmlElementView` sets `video.src = 'assets/videos/120172-720504774.mp4'` — a relative path that the browser resolves to `/assets/videos/120172-720504774.mp4`. That path does not exist on Firebase Hosting. Firebase's SPA rewrite rule (`"**" → /index.html`) intercepts it and returns the Flutter HTML shell (703 bytes) instead of the video. The browser receives an HTML page with `Content-Type: video/mp4`, which it cannot decode, so the video element stays blank (grey).**

Desktop is unaffected because `VideoPlayerController.asset()` uses Flutter's internal asset loader which already knows the correct internal path (`/assets/assets/videos/...`).

There are **no codec problems**, **no CORS problems**, and **no Firebase configuration problems** with the video itself — it is a pure URL path error in the mobile code path.

---

## Evidence

### 1. HTTP HEAD on the URL the mobile browser actually requests

```
GET /assets/videos/120172-720504774.mp4
→ HTTP 200 OK
   Content-Length: 703          ← 703 bytes — this is the HTML shell, NOT a 6 MB video
   Content-Type: video/mp4      ← Firebase headers rule applies, but content is HTML
   Accept-Ranges: bytes
```

The video file is **6,488,621 bytes (6.19 MB)** on disk. Receiving 703 bytes is conclusive proof the wrong file is being served.

### 2. `index.html` is exactly 703 bytes

```
build/web/index.html → 703 bytes
```

The rewrite rule `{"source": "**", "destination": "/index.html"}` catches `/assets/videos/...` (no real file at that path) and serves `index.html`. The `**/*.mp4` headers rule then stamps `Content-Type: video/mp4` on top of it.

### 3. First 20 bytes confirm it is HTML

```bash
curl -s https://nexora-web-731248589799.web.app/assets/videos/120172-720504774.mp4 | head -c 20
→ <!DOCTYPE html
```

### 4. Where the video actually lives in the build

Flutter Web copies project assets into a **double-nested path**:

```
build/web/assets/assets/videos/120172-720504774.mp4   ← 6,488,621 bytes ✓
```

The correct URL on Firebase Hosting is therefore:

```
/assets/assets/videos/120172-720504774.mp4
```

### 5. Correct URL works

```
GET /assets/assets/videos/120172-720504774.mp4
→ HTTP 200 OK
   Content-Type: video/mp4
   Accept-Ranges: bytes
   (no Content-Length — chunked transfer of full file)
```

First bytes: `ftypisom isom` — valid MP4 container.

### 6. Range requests also work on the correct URL

```
GET /assets/assets/videos/120172-720504774.mp4
   Range: bytes=0-1023
→ HTTP 200 OK   (server supports Accept-Ranges)
```

### 7. The mobile code path (`site_video_background.dart`)

```dart
// Line 70 — HtmlElementView callback
video.src = 'assets/videos/120172-720504774.mp4';
```

This is a relative URL. With `<base href="/">` in the compiled `index.html`, the browser resolves it to `/assets/videos/120172-720504774.mp4` — the wrong path.

`VideoPlayerController.asset()` (desktop path) routes through Flutter's asset bundle mechanism, which internally knows the double-`assets/` prefix. That is why desktop works and mobile does not.

### 8. Asset manifest confirms the logical key

The `AssetManifest.bin.json` registers the asset under key:
```
assets/videos/120172-720504774.mp4
```
Flutter translates that key to the real URL `/assets/assets/videos/...` internally. The `HtmlElementView` code bypasses this translation.

### 9. Video file — no codec issues found

- Source file: `assets/videos/120172-720504774.mp4` — 6.19 MB, last modified 2026-10-15
- Build copy: `build/web/assets/assets/videos/120172-720504774.mp4` — same size ✓
- Container: `ftypisom isom` (standard MP4, universally supported)
- `ffprobe` not available in this environment — codec stream details could not be extracted, but the container is valid and the file is fully accessible at the correct URL

### 10. `firebase.json` — headers are fine, rewrite is the trap

```json
"headers": [
  { "source": "**/*.mp4",
    "headers": [
      { "key": "Accept-Ranges", "value": "bytes" },
      { "key": "Content-Type", "value": "video/mp4" },
      ...
    ]
  }
],
"rewrites": [{"source": "**", "destination": "/index.html"}]
```

The headers rule is correct. The rewrite is a standard Flutter SPA rewrite and is also correct — it just means any non-existent path silently returns HTML. The `**/*.mp4` header rule applies **after** the rewrite delivers `index.html`, which is why the response looks like a video but isn't.

---

## Secondary Issues

### `Cache-Control: no-cache, no-store, must-revalidate` on MP4

This is overly aggressive for a 6 MB video and will cause the browser to re-fetch it on every page load. Not a correctness bug but a performance concern — consider `Cache-Control: public, max-age=31536000, immutable` with content-hashed filenames if the video rarely changes.

### `HtmlElementView.fromTagName` — no error handling

The current mobile implementation sets `video.src` but never calls `video.load()` or `video.play()`, attaches no `onerror` listeners, and does not handle autoplay policy rejections. This means errors are silent.

---

## Recommended Fix (implement nothing here — diagnosis only)

### Fix 1 — Correct the video `src` URL in `site_video_background.dart`

Change line 70 from:
```dart
video.src = 'assets/videos/120172-720504774.mp4';
```
to:
```dart
video.src = 'assets/assets/videos/120172-720504774.mp4';
```

This is the minimal, targeted fix. The double `assets/` prefix is the actual URL path on Firebase Hosting.

**Alternative (more robust):** derive the path from Flutter's asset bundle at runtime:

```dart
import 'package:flutter/services.dart';
// In initState or onElementCreated (if async is acceptable):
final assetPath = await rootBundle.load('assets/videos/120172-720504774.mp4');
// ... but HtmlElementView.onElementCreated is synchronous.
```

Because `onElementCreated` is synchronous, hardcoding `'assets/assets/videos/120172-720504774.mp4'` is the simplest correct fix. The path is determined by Flutter's build output convention, which is stable.

### Fix 2 — Add error handling and `video.load()` + `video.play()`

```dart
video.src = 'assets/assets/videos/120172-720504774.mp4';
video.autoplay = true;
video.loop = true;
video.muted = true;
video.setAttribute('playsinline', 'true');
video.setAttribute('webkit-playsinline', 'true');
video.style.width = '100%';
video.style.height = '100%';
video.style.objectFit = 'cover';
video.load();  // explicit load call
video.addEventListener('canplay', (web.Event _) {
  video.play();
}.toJS);
video.addEventListener('error', (web.Event e) {
  debugPrint('[VideoBackground] load error: ${video.error?.message}');
}.toJS);
```

### Fix 3 — Autoplay policy fallback

iOS Safari and Chrome on Android may block autoplay even with `muted`. If `play()` is rejected:
- Keep the `Color(0xFF0D0618)` background visible (already implemented as fallback)
- Optionally add a tap-to-play overlay if product requirements permit

### Fix 4 (optional) — Cache-Control for video assets

In `firebase.json`, change MP4 cache header to something less aggressive:
```json
{ "key": "Cache-Control", "value": "public, max-age=3600" }
```

---

## Files Involved

| File | Issue |
|------|-------|
| `lib/presentation/widgets/site_video_background.dart` | Line 70: wrong relative URL for `video.src` |
| `firebase.json` | No structural issue; `**` rewrite silently eats wrong-path requests |
| `build/web/index.html` | Confirms 703 bytes = HTML shell served at wrong video URL |

---

## Checks That Cannot Be Done Without Physical Devices

- Confirm autoplay policy behavior on iOS Safari 16/17
- Confirm playback on Chrome Android 114+
- Confirm `playsinline` attribute prevents full-screen takeover on iOS
- Verify `webkit-playsinline` is still required (it was deprecated but some older iOS versions still need it)
- Test background tab → foreground resume behavior on mobile
