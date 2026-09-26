// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';
import 'core/di/injection.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppLogger.info('🚀 Starting AnimeWeebs...');
  
  Bloc.observer = AppBlocObserver();
  
  await initDependencies();
  await initHive();
  
  runApp(const App());
}

Future<void> initHive() async {
  try {
    AppLogger.info('📦 Initializing Hive...');
    
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    await Hive.openBox('anime_cache');  
    await Hive.openBox('watch_history');
    await Hive.openBox('user_preferences');
    await Hive.openBox('continue_watching');
    
    AppLogger.success('✅ Hive initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('❌ Failed to initialize Hive', e, stackTrace);
    rethrow;
  }
}