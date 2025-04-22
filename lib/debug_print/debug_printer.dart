import 'package:flutter/material.dart';

class DebugPrinter {
  static const String _TAG = 'DEBUG:';
  static bool cfgIsDebugMode = false;

  static void success(String message) {
    if (cfgIsDebugMode) {
      debugPrint('✅ $_TAG: SUCCESS: $message');
    }
  }

  static void info(String message) {
    if (cfgIsDebugMode) {
      debugPrint('📘🚀 $_TAG: INFO: $message');
    }
  }

  static void warn(String message) {
    if (cfgIsDebugMode) {
      debugPrint('🔥⚠️  $_TAG: WARNING: $message');
    }
  }

  static void error(String message) {
    if (cfgIsDebugMode) {
      debugPrint('❌ $_TAG: ERROR: $message');
    }
  }

  static void seperator() {
    if (cfgIsDebugMode) {
      debugPrint("-" * 50);
    }
  }
}
