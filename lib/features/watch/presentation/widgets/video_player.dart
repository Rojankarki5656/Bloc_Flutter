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
  final int? episodeNumber;
  final String? animeId;

  const VideoPlayer({
    super.key,
    required this.servers,
    this.isLoading = false,
    this.isError = false,
    this.theaterMode = false,
    this.episodeNumber,
    this.animeId,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  WebViewController? _controller;
  int _currentServerIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.servers.isNotEmpty) {
      _initController();
    }
  }

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reload when servers change
    if (widget.servers.isNotEmpty && 
        (oldWidget.servers.isEmpty || 
         oldWidget.servers[0].url != widget.servers[0].url)) {
      _initController();
    }
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            AppLogger.debug('🌐 Player started: $url');
          },
          onPageFinished: (url) {
            AppLogger.debug('✅ Player finished: $url');
          },
          onWebResourceError: (error) {
            AppLogger.error(
              '❌ WebView Error ${error.errorCode}: ${error.description}',
            );
          },
        ),
      );

    _loadPlayer();
  }

  Future<void> _loadPlayer() async {
    if (_controller == null) return;

    final url = widget.servers[_currentServerIndex].url;
    AppLogger.info('🎬 Loading player URL: $url');

    // ✅ Load iframe HTML directly
    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background: #000;
      overflow: hidden;
    }
    iframe {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      border: none;
    }
  </style>
</head>
<body>
  <iframe
    src="$url"
    allowfullscreen
    allow="autoplay; fullscreen; encrypted-media; picture-in-picture">
  </iframe>
</body>
</html>
''';

    await _controller!.loadHtmlString(html);
  }

  void _switchServer(int index) {
    if (index == _currentServerIndex) return;
    setState(() {
      _currentServerIndex = index;
    });
    _loadPlayer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoading();
    }

    if (widget.isError || widget.servers.isEmpty) {
      return _buildError();
    }

    if (_controller == null) {
      return _buildLoading();
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
        child: Stack(
          children: [
            WebViewWidget(controller: _controller!),
            
            // Server switcher (if multiple servers)
            if (widget.servers.length > 1)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.servers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final server = entry.value;
                      final isActive = index == _currentServerIndex;
                      
                      return GestureDetector(
                        onTap: () => _switchServer(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppTheme.primaryGold
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            server.language.toUpperCase(),
                            style: AppTheme.labelSmall.copyWith(
                              color: isActive
                                  ? AppTheme.backgroundColor
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
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