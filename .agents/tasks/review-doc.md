# Nexora UI Fixes: White Text, iPhone Hero, CTA Redesign

Three UI corrections applied to the Nexora Flutter web project: replacing dark text with white across all public-facing pages (video background visibility), adding a phone illustration to the home hero section, and reshaping the CTA section on the home page to match the service pages pattern.

Watch for: `_GameTechnologies` technology card names have no explicit text color — they default to dark on a white card background, which is intentional (plan explicitly marks these "не менять"). All five blocking criteria pass cleanly.

**Verdict**: APPROVED

---

## High-level view

`site_video_background.dart` carries the critical syntax fix: `?widget.child,` replaced with `if (widget.child != null) widget.child!,`. The file is valid Dart and the project builds.

Home hero now renders `_PhoneIllustration` on the right (desktop, ≥850px) or bottom (mobile) via an adaptive Row/Column. The illustration is a pure-Flutter phone mockup, no asset dependency, copied from `mobile_development_page.dart`.

CTA section `_HomeContactSection` matches the service-page pattern: purple `Color(0xFF4412A7)` background, `Colors.white` heading, `Colors.white70` subtext, white `ElevatedButton` with `foregroundColor: Color(0xFF4412A7)`. Column is left-aligned, center alignment removed.

Text color corrections are confirmed across all eight checked files. The only dark text remaining on public pages is inside explicitly white-background card widgets — `_TeamCard` (about page), `_GameTypeCard`/`_GameProjectCard` (game page, `isHover=false`), `_GameTechnologies` tile, `_serviceCard` (ML page) — all of which sit on white surfaces and are correctly excluded from the white-text rule.

`flutter analyze` reports 7 info-level deprecation notices, all in `admin_login_page.dart` and `contacts_widget.dart`, both excluded from modification scope. Zero errors in any modified file.

---

<details>
<summary>Issues (0)</summary>

No blocking issues found.

</details>

<details>
<summary>Details</summary>

### Syntax fix in `site_video_background.dart`

The invalid `?widget.child,` spread operator replaced with:

```dart
if (widget.child != null) widget.child!,
```

Syntactically valid, semantically equivalent — conditionally includes the child in the Stack children list only when non-null.

### Phone illustration in home hero

`_HomeHero` restructured from `ConstrainedBox(maxWidth: 760)` + `Column` to an adaptive layout. `_heroText` helper extracted. `_PhoneIllustration` class added at file end, identical to `mobile_development_page.dart`'s version. Hero heading `Colors.white`, subtitle `Colors.white70`.

### CTA section matches service page pattern

`_HomeContactSection`: heading gets `color: Colors.white` (was missing), subtitle `Colors.black54` → `Colors.white70`, button switches from `backgroundColor: Color(0xFF4412A7)` (invisible on purple container) to `backgroundColor: Colors.white` / `foregroundColor: Color(0xFF4412A7)`. `Column.crossAxisAlignment` → `CrossAxisAlignment.start`, `textAlign: TextAlign.center` removed.

### Text color sweep — confirmed clean

- `about_page.dart`: no `Colors.black*` remaining in public sections. `_buildFooter` uses `Colors.white38` for copyright. `_TeamCard` keeps dark text on white card — correct.
- `services_section.dart`: all section headers and descriptions white/white70. Dividers `Color(0x33FFFFFF)`.
- `technologies_section.dart`: heading and description white/white70. Card items use gradient overlay with white text — unchanged.
- `mobile_development_page.dart`: all hero, services, technologies, process, projects texts white/white70. `_ProjectCard` at `isHover=false` keeps dark text on white — correct.
- `game_development_page.dart`: all section headers white. `_GameTechnologies` card names have no explicit color (renders dark on white card) — plan says "Не менять," confirmed intentional. `_GameProjectCard`/`_GameTypeCard` at `isHover=false` dark text on white — correct.
- `machine_learning.dart`: hero, process cards, contact all white/white70. `_serviceCard` keeps `Colors.black54` on white card background — correct per plan.

### `flutter analyze`

7 info-level issues in excluded files only. `withOpacity` is replaced by `withValues(alpha:)` in modified files.

### `web_development_page.dart`

`Scaffold(backgroundColor: Colors.white)` — white background page excluded from dark-text rule. File is unchanged.

</details>

---

## File map

<details>
<summary>Changed files</summary>

- `lib/presentation/widgets/site_video_background.dart` — syntax fix: `?widget.child,` → `if (widget.child != null) widget.child!`
- `lib/presentation/pages/home_page.dart` — hero with phone illustration; CTA section white texts and white button
- `lib/presentation/pages/about_page.dart` — all public-section texts white/white70; footer copyright white38
- `lib/presentation/widgets/services_section.dart` — process/services texts white; dividers translucent white
- `lib/presentation/widgets/technologies_section.dart` — heading and description white/white70
- `lib/presentation/mobile_screen_folders/screens/mobile_development_page.dart` — hero, services, technologies, process, projects texts white/white70
- `lib/presentation/mobile_screen_folders/screens/game_development_page.dart` — all section texts white/white70; technology card names intentionally dark on white cards
- `lib/presentation/mobile_screen_folders/screens/machine_learning.dart` — hero, process, contact texts white/white70
- `lib/presentation/mobile_screen_folders/screens/web_development_page.dart` — unchanged (white background page, excluded from scope)

</details>
