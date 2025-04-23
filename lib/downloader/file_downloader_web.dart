import 'dart:html';

import 'package:flutter_guarded_download/enums/method_enum.dart';
import 'package:flutter_guarded_download/services/data_services.dart';

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
      // ask for the file Name
      String actualFileName = fileName ?? _getFileNameFromUrl(downloadUrl);

      //
      final response = await DataServices.fileDownload(downloadUrl,
          token: token, method: method);

      if (response.statusCode != 200)
        return onError?.call('Downloaded file is empty');

      // Create a URL for the Blob
      final url =
          Url.createObjectUrlFromBlob(Blob([await response?.stream.toBytes()]));

      // Create an anchor element with the URL
      final anchor = AnchorElement(href: url)
        ..setAttribute('download', actualFileName)
        ..target = 'blank'
        ..style.display = 'none'
        ..download = fileName;

      // Programmatically click the anchor to start the download
      anchor.click();

      Url.revokeObjectUrl(url);

      onCompleted?.call(actualFileName);
    } catch (e) {
      onError?.call('Error downloading file: $e'); //
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
