// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';

// import 'app/app.dart';
// import 'app/app_bloc_observer.dart';
// import 'core/di/injection.dart';
// import 'core/utils/logger.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   AppLogger.info('🚀 Starting AnimeWeebs...');
  
//   Bloc.observer = AppBlocObserver();
  
//   await initDependencies();
//   await initHive();
  
//   runApp(const App());
// }

// Future<void> initHive() async {
//   try {
//     AppLogger.info('📦 Initializing Hive...');
    
//     final appDocumentDir = await getApplicationDocumentsDirectory();
//     Hive.init(appDocumentDir.path);
    
//     await Hive.openBox('anime_cache');  
//     await Hive.openBox('watch_history');
//     await Hive.openBox('user_preferences');
//     await Hive.openBox('continue_watching');
    
//     AppLogger.success('✅ Hive initialized successfully');
//   } catch (e, stackTrace) {
//     AppLogger.error('❌ Failed to initialize Hive', e, stackTrace);
//     rethrow;
//   }
// }


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const VideoPage(),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('Started: $url');
          },
          onPageFinished: (url) {
            debugPrint('Finished: $url');
          },
          onWebResourceError: (error) {
            debugPrint(
              'Error ${error.errorCode}: ${error.description}',
            );
          },
        ),
      );

    _loadPlayer();
  }

  Future<void> _loadPlayer() async {
    const html = '''
<!DOCTYPE html>
<html>
<head>
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0"
  >

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
      width: 100%;
      height: 100%;
      border: none;
    }
  </style>
</head>

<body>

  <iframe
    src="https://megavid.buzz/ani/21/1/dub"
    allowfullscreen>
  </iframe>

</body>
</html>
''';

    await _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}