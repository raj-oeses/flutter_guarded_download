import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter_guarded_download/enums/method_enum.dart';
import 'package:http/http.dart' as http;

import 'file_downloader_interface.dart';

///Instance
FileDownloaderInterface getInstance() => WebFileDownloader();

/// Web implementation of FileDownloaderInterface
class WebFileDownloader implements FileDownloaderInterface {
  @override
  Future<void> downloadFile(
      {required String downloadUrl,
      String? fileName,
      String? token,
      DownloadMethod method = DownloadMethod.GET,
      ProgressCallback? onProgress,
      CompletedCallback? onCompleted,
      ErrorCallback? onError}) async {
    try {
      String actualFileName = fileName ?? _getFileNameFromUrl(downloadUrl);

      Uint8List fileData;

      // Download the file based on the method
      fileData = await _download(downloadUrl,
          token: token,
          method: method,
          onProgress: onProgress,
          onError: onError);

      if (fileData.isEmpty) {
        onError?.call('Downloaded file is empty');
        return;
      }

      // Create a blob from the file data
      final blob = html.Blob([fileData]);

      // Create a URL for the blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create a temporary link element
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', actualFileName)
        ..style.display = 'none';

      // Add the link to the document
      html.document.body?.append(anchor);

      // Trigger a click on the link to start the download
      anchor.click();

      // Clean up
      html.Url.revokeObjectUrl(url);
      anchor.remove();

      onCompleted?.call(actualFileName);
    } catch (e) {
      onError?.call('Error downloading file: $e');
    }
  }

  Future<Uint8List> _download(String url,
      {String? token,
      DownloadMethod method = DownloadMethod.GET,
      ProgressCallback? onProgress,
      ErrorCallback? onError}) async {
    try {
      final _headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null) {
        _headers['Authorization'] = 'Bearer $token';
      }
      print('_header $_headers');
      print('Method $method');

      final response = method == DownloadMethod.GET
          ? await http.get(Uri.parse(url), headers: _headers)
          : await http.post(Uri.parse(url), headers: _headers);

      if (response.statusCode != 200) {
        onError?.call('Failed to download file: HTTP ${response.statusCode}');
        return Uint8List(0);
      }

      // Web implementation doesn't support progress tracking with standard http package
      // We could switch to XMLHttpRequest in a future implementation
      onProgress?.call(response.bodyBytes.length, response.bodyBytes.length);

      return response.bodyBytes;
    } catch (e) {
      onError?.call('Error during GET download: $e');
      return Uint8List(0);
    }
  }

  /// Web doesn't need special permissions for downloading
  @override
  Future<bool> checkPermission() async => true;

  String _getFileNameFromUrl(String url) {
    try {
      return url.split('/').last;
    } catch (_) {
      return 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
