// lib/features/watch/presentation/widgets/video_player.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/server.dart';

class VideoPlayer extends StatefulWidget {
  final List<StreamingServer> servers;
  final bool isLoading;
  final bool isError;
  final bool theaterMode;
  final Function(int currentTime, int duration, int progress)? onProgress;

  const VideoPlayer({
    super.key,
    required this.servers,
    this.isLoading = false,
    this.isError = false,
    this.theaterMode = false,
    this.onProgress,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late WebViewController _controller;
  int _currentServerIndex = 0;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            AppLogger.debug('🌐 Loading: $progress%');
          },
          onPageStarted: (String url) {
            AppLogger.debug('🌐 Page started: $url');
          },
          onPageFinished: (String url) {
            AppLogger.debug('🌐 Page finished: $url');
          },
          onWebResourceError: (WebResourceError error) {
            AppLogger.error('🌐 WebView error: ${error.description}');
          },
        ),
      );

    _loadCurrentServer();
  }

  @override
  void didUpdateWidget(covariant VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldUrl =
        oldWidget.servers.isNotEmpty ? oldWidget.servers.first.url : null;
    final newUrl = widget.servers.isNotEmpty ? widget.servers.first.url : null;

    if (newUrl != null && newUrl != oldUrl) {
      _currentServerIndex = 0;
      _loadCurrentServer();
    }
  }

  void _loadCurrentServer() {
    if (widget.servers.isEmpty || !mounted) return;

    if (_currentServerIndex >= widget.servers.length) {
      _currentServerIndex = 0;
    }

    final url = widget.servers[_currentServerIndex].url;
    if (url.isEmpty) return;

    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoading();
    }

    if (widget.isError || widget.servers.isEmpty) {
      return _buildError();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: widget.theaterMode
            ? BorderRadius.zero
            : BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryGold,
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: AppTheme.errorColor,
                size: 48.sp,
              ),
              SizedBox(height: 12.h),
              Text(
                widget.isError
                    ? 'Failed to load video'
                    : 'No video source available',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
