import 'package:flutter_guarded_download/enums/method_enum.dart';

import 'file_downloader_interface.dart';
import 'file_downloader_stub.dart'
    if (dart.library.html) 'file_downloader_web.dart'
    if (dart.library.io) 'file_downloader_mobile.dart';

/// Main class that provides a platform-agnostic API for downloading files
class FileDownloader {
  /// Private constructor
  FileDownloader._();

  /// The singleton instance of [FileDownloader]
  static final FileDownloader _instance = FileDownloader._();

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
          ErrorCallback? onError}) async =>
      _implementation.downloadFile(
          downloadUrl: downloadUrl,
          fileName: fileName,
          token: token,
          method: method,
          onProgress: onProgress,
          onCompleted: onCompleted,
          onError: onError);

  /// Checks if the app has permission to save files
  ///
  /// Returns true if permission is granted, false otherwise
  Future<bool> checkPermission() async => _implementation.checkPermission();
}
