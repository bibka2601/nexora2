import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SiteVideoBackground extends StatefulWidget {
  const SiteVideoBackground({super.key, required this.child});

  final Widget? child;

  @override
  State<SiteVideoBackground> createState() => _SiteVideoBackgroundState();
}

class _SiteVideoBackgroundState extends State<SiteVideoBackground> {
  late final VideoPlayerController _controller =
      VideoPlayerController.networkUrl(
    Uri.parse(
      'https://res.cloudinary.com/yqbdknq8/video/upload/v1792436882/120172-720504774.mp4',
    ),
  );
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onUpdate);
    _controller.initialize().then((_) {
      if (mounted) {
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
        setState(() => _videoReady = true);
      }
    }).catchError((_) {});
  }

  void _onUpdate() {
    if (!mounted) return;
    if (!_videoReady && _controller.value.isInitialized) {
      setState(() => _videoReady = true);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_videoReady)
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        else
          const ColoredBox(color: Color(0xFF0D0618)),
        Positioned.fill(
          child: ColoredBox(
            color: Colors.black.withValues(alpha: 0.45),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}


