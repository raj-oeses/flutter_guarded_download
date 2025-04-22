import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter_guarded_download/debug_print/debug_printer.dart';
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
    DebugPrinter.info(':::::::::::::::::Download File:::::::::::::::::');
    try {
    //   String actualFileName = fileName ?? _getFileNameFromUrl(downloadUrl);
    //
    //   Uint8List fileData;
    //
    //   // Download the file based on the method
    //   if (method == DownloadMethod.GET) {
    //     fileData =
    //         await _downloadWithGet(downloadUrl, token, onProgress, onError);
    //   } else {
    //     fileData =
    //         await _downloadWithPost(downloadUrl, token, onProgress, onError);
    //   }
    //
    //   if (fileData.isEmpty) {
    //     onError?.call('Downloaded file is empty');
    //     return;
    //   }
    //
    //   // Create a blob from the file data
    //   final blob = html.Blob([fileData]);
    //
    //   // Create a URL for the blob
    //   final url = html.Url.createObjectUrlFromBlob(blob);
    //
    //   // Create a temporary link element
    //   final anchor = html.AnchorElement(href: url)
    //     ..setAttribute('download', actualFileName)
    //     ..style.display = 'none';
    //
    //   // Add the link to the document
    //   html.document.body?.append(anchor);
    //
    //   // Trigger a click on the link to start the download
    //   anchor.click();
    //
    //   // Clean up
    //   html.Url.revokeObjectUrl(url);
    //   anchor.remove();
    //
    //   onCompleted?.call(actualFileName);
    } catch (e) {
      onError?.call('Error downloading file: $e');
    }
  }

  Future<Uint8List> _downloadWithGet(String url, String? token,
      ProgressCallback? onProgress, ErrorCallback? onError) async {
    try {
      final headers = <String, String>{};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(Uri.parse(url), headers: headers);

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

  Future<Uint8List> _downloadWithPost(String url, String? token,
      ProgressCallback? onProgress, ErrorCallback? onError) async {
    DebugPrinter.info('here is the URL $url\n token:::::$token');
    try {
      final headers = <String, String>{};
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode != 200) {
        onError?.call('Failed to download file: HTTP ${response.statusCode}');
        return Uint8List(0);
      }

      // Web implementation doesn't support progress tracking with standard http package
      onProgress?.call(response.bodyBytes.length, response.bodyBytes.length);

      return response.bodyBytes;
    } catch (e) {
      onError?.call('Error during POST download: $e');
      return Uint8List(0);
    }
  }

  @override
  Future<bool> checkPermission() async {
    // Web doesn't need special permissions for downloading
    return true;
  }

  @override
  Future<bool> requestPermission() async {
    // Web doesn't need special permissions for downloading
    return true;
  }

  String _getFileNameFromUrl(String url) {
    try {
      return url.split('/').last;
    } catch (_) {
      return 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}

// // web_file_downloader.dart
// import 'dart:html';
//
// import 'package:flutter_guarded_download/debug_print/debug_printer.dart';
// import 'package:flutter_guarded_download/enums/method_enum.dart';
// import 'package:flutter_guarded_download/services/data_access_service.dart';
//
// import 'file_downloader_interface.dart';
//
// IFileDownloader getInstance() => FileDownloaderWeb();
//
// class FileDownloaderWeb extends IFileDownloader {
//   @override
//   Future downloadFile(String downloadUrl,
//       {String? token,
//       String? fileName,
//       MethodEnum? method,
//       Function(double progress)? onProgress,
//       Function(String progress)? onCompleted,
//       Function(String progress)? onError}) async {
//     try {
//       // final response = await getIt<VendorService>()
//       //     .downloadReportMobile(params, reportOption);
//       final response =
//           await DataAccessService.fileDownload(downloadUrl, token: token);
//
//       // Create a URL for the Blob
//       final url =
//           Url.createObjectUrlFromBlob(Blob([await response?.stream.toBytes()]));
//
//       // Create an anchor element with the URL
//       final anchor = AnchorElement(href: url)
//         ..target = 'blank'
//         ..download = fileName;
//
//       // Programmatically click the anchor to start the download
//       anchor.click();
//
//       Url.revokeObjectUrl(url);
//     } catch (e) {
//       DebugPrinter.error(':::::::::::::$e');
//       throw UnimplementedError();
//     }
//     throw UnimplementedError();
//   }
// }
