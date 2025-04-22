import 'dart:async';

import 'package:flutter_guarded_download/enums/method_enum.dart';

/// Callback to track download progress
typedef ProgressCallback = void Function(int receivedBytes, int totalBytes);

/// Callback when download is completed
typedef CompletedCallback = void Function(String filePath);

/// Callback when an error occurs during download
typedef ErrorCallback = void Function(String error);

/// Interface for file downloader implementations
abstract class FileDownloaderInterface {
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
      ErrorCallback? onError});

  /// Checks if the app has permission to save files
  /// Returns true if permission is granted, false otherwise
  Future<bool> checkPermission();
}
