import 'package:flutter_guarded_download/debug_print/debug_printer.dart';

import 'file_downloader_interface.dart';
import 'file_downloader_stub.dart'
    if (dart.library.html) 'file_downloader_web.dart'
    if (dart.library.io) 'file_downloader_mobile.dart';

// file_downloader.dart
//
// import 'package:flutter/foundation.dart' show kIsWeb;
// // import 'file_downloader_interface.dart';
// import 'file_downloader_interface.dart';
// import 'file_downloader_mobile.dart';
// import 'file_downloader_web.dart';

// import 'mobile_file_downloader.dart';
// import 'web_file_downloader.dart';

/// Main class that provides a platform-agnostic API for downloading files
class FileDownloader {
  /// Private constructor
  FileDownloader._internal();

  /// The singleton instance of [FileDownloader]
  static final FileDownloader _instance = FileDownloader._internal();

  /// Factory constructor to return the singleton instance
  factory FileDownloader() => _instance;

  /// The platform-specific implementation of [FileDownloaderInterface]
  late final FileDownloaderInterface _implementation = getInstance();

  /// Downloads a file from the given URL
  ///
  /// [downloadUrl] - URL to download the file from
  /// [fileName] - Optional name for the downloaded file
  /// [token] - Optional authorization token for secure downloads
  /// [method] - HTTP method to use (GET or POST)
  /// [onProgress] - Optional callback to track download progress
  /// [onCompleted] - Optional callback when download is completed
  /// [onError] - Optional callback when an error occurs
  Future<void> downloadFile(
      {required String downloadUrl,
      String? fileName,
      String? token,
      DownloadMethod method = DownloadMethod.GET,
      ProgressCallback? onProgress,
      CompletedCallback? onCompleted,
      ErrorCallback? onError}) async {
    DebugPrinter.info('::::::::File Downloader Class::::::::');
    return _implementation.downloadFile(
        downloadUrl: downloadUrl,
        fileName: fileName,
        token: token,
        method: method,
        onProgress: onProgress,
        onCompleted: onCompleted,
        onError: onError);
  }

  /// Checks if the app has permission to save files
  ///
  /// Returns true if permission is granted, false otherwise
  Future<bool> checkPermission() async => _implementation.checkPermission();

  /// Requests permission to save files
  ///
  /// Returns true if permission is granted, false otherwise
  Future<bool> requestPermission() async => _implementation.requestPermission();
}

// import 'package:flutter_guarded_download/enums/method_enum.dart';
//
// import 'file_downloader_interface.dart';
// import 'file_downloader_stub.dart'
//     if (dart.library.html) 'file_downloader_web.dart'
//     if (dart.library.io) 'file_downloader_mobile.dart';
//
// class FileDownloader {
//   // Private constructor to prevent direct instantiation
//   FileDownloader._();
//
//   // Singleton instance
//   static final FileDownloader _instance = FileDownloader._();
//
//   // Factory constructor to return the singleton instance
//   factory FileDownloader() => _instance;
//
//   // The platform-specific downloader instance
//   static final IFileDownloader _downloader = getInstance();
//
//   // Public method to download files
//   static Future downloadFile(String downloadUrl,
//           {String? token,
//           String? fileName,
//           MethodEnum? method,
//           Function(double progress)? onProgress,
//           Function(String progress)? onCompleted,
//           Function(String progress)? onError}) {
//      return _downloader.downloadFile(downloadUrl,
//          token: token,
//          fileName: fileName,
//          method: method,
//          onProgress: onProgress,
//          onCompleted: onCompleted,
//          onError: onError);
//    }
//
// }
