// lib/features/watch/data/datasources/watch_local_datasource.dart
import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repository/i_watch_repository.dart';

class WatchLocalDataSource {
  final Box _box;
  static const String boxName = 'watch_history';

  WatchLocalDataSource(this._box);

  /// Save watch progress
  Future<void> saveProgress(WatchProgress progress) async {
    try {
      await _box.put(progress.animeId, progress.toJson());
      AppLogger.debug('💾 Saved progress for ${progress.animeId}');
    } catch (e) {
      AppLogger.error('❌ Failed to save progress', e);
      rethrow;
    }
  }

  /// Get watch progress for an anime
  WatchProgress? getProgress(String animeId) {
    try {
      final data = _box.get(animeId);
      if (data == null) return null;

      if (data is Map) {
        return WatchProgress.fromJson(Map<String, dynamic>.from(data));
      }

      if (data is String) {
        final decoded = jsonDecode(data);
        return WatchProgress.fromJson(Map<String, dynamic>.from(decoded));
      }

      return null;
    } catch (e) {
      AppLogger.error('❌ Failed to get progress for $animeId', e);
      return null;
    }
  }

  /// Get all watch progress entries sorted by date
  List<WatchProgress> getAllProgress() {
    try {
      final entries = <WatchProgress>[];
      for (final key in _box.keys) {
        final progress = getProgress(key.toString());
        if (progress != null) {
          entries.add(progress);
        }
      }
      // Sort by updatedAt (most recent first)
      entries.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return entries;
    } catch (e) {
      AppLogger.error('❌ Failed to get all progress', e);
      return [];
    }
  }

  /// Remove watch progress
  Future<void> removeProgress(String animeId) async {
    try {
      await _box.delete(animeId);
      AppLogger.debug('🗑️ Removed progress for $animeId');
    } catch (e) {
      AppLogger.error('❌ Failed to remove progress', e);
    }
  }

  /// Clear all watch history
  Future<void> clearAll() async {
    try {
      await _box.clear();
      AppLogger.debug('🗑️ Cleared all watch history');
    } catch (e) {
      AppLogger.error('❌ Failed to clear watch history', e);
    }
  }

  /// Export watch history as JSON
  Map<String, dynamic> exportData() {
    final data = <String, dynamic>{};
    for (final key in _box.keys) {
      data[key.toString()] = _box.get(key);
    }
    return data;
  }

  /// Import watch history from JSON
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      for (final entry in data.entries) {
        await _box.put(entry.key, entry.value);
      }
      AppLogger.info('✅ Imported ${data.length} watch history entries');
    } catch (e) {
      AppLogger.error('❌ Failed to import watch history', e);
      rethrow;
    }
  }
}