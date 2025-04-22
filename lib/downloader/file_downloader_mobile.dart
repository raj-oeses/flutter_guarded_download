// mobile_file_downloader.dart

import 'dart:io';

import 'package:flutter_guarded_download/debug_print/debug_printer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_downloader_interface.dart';

///Instance
FileDownloaderInterface getInstance() => MobileFileDownloader();

/// Mobile implementation of FileDownloaderInterface
class MobileFileDownloader implements FileDownloaderInterface {
  @override
  Future<void> downloadFile({
    required String downloadUrl,
    String? fileName,
    String? token,
    DownloadMethod method = DownloadMethod.GET,
    ProgressCallback? onProgress,
    CompletedCallback? onCompleted,
    ErrorCallback? onError,
  }) async {
    DebugPrinter.info(':::::::::::::::Mobile Download::::::::::::');
    try {
      // Check if we have permission to write files
      bool hasPermission = await checkPermission();
      if (!hasPermission) {
        hasPermission = await requestPermission();
        if (!hasPermission) {
          onError?.call('Storage permission denied');
          return;
        }
      }

      // Determine the file name
      String actualFileName = fileName ?? _getFileNameFromUrl(downloadUrl);

      // Get the directory to save files
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        onError?.call('Could not determine download directory');
        return;
      }

      // Create the file path
      String filePath = '${directory.path}/$actualFileName';
      File file = File(filePath);

      // Perform the download
      if (method == DownloadMethod.GET) {
        await _downloadWithGet(
            downloadUrl, file, token, onProgress, onCompleted, onError);
      } else {
        await _downloadWithPost(
            downloadUrl, file, token, onProgress, onCompleted, onError);
      }
    } catch (e) {
      onError?.call('Error downloading file: $e');
    }
  }

  Future<void> _downloadWithGet(
      String url,
      File file,
      String? token,
      ProgressCallback? onProgress,
      CompletedCallback? onCompleted,
      ErrorCallback? onError) async {
    try {
      final request = http.Request('GET', Uri.parse(url));

      // Add token if provided
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        onError?.call('Failed to download file: HTTP ${response.statusCode}');
        return;
      }

      final contentLength = response.contentLength ?? 0;
      int receivedBytes = 0;

      final IOSink sink = file.openWrite();
      await response.stream.forEach((List<int> chunk) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        onProgress?.call(receivedBytes, contentLength);
      });

      await sink.flush();
      await sink.close();

      onCompleted?.call(file.path);
    } catch (e) {
      onError?.call('Error during GET download: $e');
    }
  }

  Future<void> _downloadWithPost(
      String url,
      File file,
      String? token,
      ProgressCallback? onProgress,
      CompletedCallback? onCompleted,
      ErrorCallback? onError) async {
    try {
      final request = http.Request('POST', Uri.parse(url));

      // Add token if provided
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        onError?.call('Failed to download file: HTTP ${response.statusCode}');
        return;
      }

      final contentLength = response.contentLength ?? 0;
      int receivedBytes = 0;

      final IOSink sink = file.openWrite();
      await response.stream.forEach((List<int> chunk) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        onProgress?.call(receivedBytes, contentLength);
      });

      await sink.flush();
      await sink.close();

      onCompleted?.call(file.path);
    } catch (e) {
      onError?.call('Error during POST download: $e');
    }
  }

  @override
  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      return await Permission.storage.isGranted;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit permission for app directory
      return true;
    }
    return false;
  }

  @override
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit permission for app directory
      return true;
    }
    return false;
  }

  String _getFileNameFromUrl(String url) {
    // Extract filename from URL or generate a unique name
    try {
      return url.split('/').last;
    } catch (_) {
      return 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}

// import 'dart:io';
//
// import 'package:flutter_guarded_download/debug_print/debug_printer.dart';
// import 'package:flutter_guarded_download/enums/method_enum.dart';
// import 'package:flutter_guarded_download/services/data_access_service.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'file_downloader_interface.dart';
//
// // Mobile download implementation
// IFileDownloader getInstance() => FileDownloaderMobile();
//
// class FileDownloaderMobile extends IFileDownloader {
//   @override
//   Future downloadFile(String downloadUrl,
//       {String? token,
//       String? fileName,
//       MethodEnum? method,
//       Function(double progress)? onProgress,
//       Function(String progress)? onCompleted,
//       Function(String progress)? onError}) async {
//     DebugPrinter.info('We are in mobile--------------- $downloadUrl');
//     final directory = await _getDownloadDirectory();
//     final filePath = '${directory.path}/$fileName';
//     final file = File(filePath);
//
//     // Create client for download
//     try {
//     //   StreamedResponse? response =
//     //       await DataAccessService.fileDownload(downloadUrl, token: token);
//     //
//     //   final contentLength = response?.contentLength ?? 0;
//     //   int bytesReceived = 0;
//     //
//     //   // Create file and write stream
//     //   final fileStream = file.openWrite();
//     //   await response?.stream.forEach((chunk) {
//     //     bytesReceived += chunk.length;
//     //     DebugPrinter.info('bytesReceived:::$bytesReceived');
//     //     fileStream.add(chunk);
//     //
//     //     // Update progress if content length is known
//     //     if (contentLength > 0 && onProgress != null) {
//     //       onProgress(bytesReceived / contentLength);
//     //     }
//     //   });
//     //
//     //   await fileStream.flush();
//     //   await fileStream.close();
//     //   return filePath;
//     } catch (e) {
//       DebugPrinter.info('Exception:::::::::::::: $e');
//     }
//
//     print('::::::::::::::::::${UnimplementedError().message}');
//     throw UnimplementedError();
//   }
//
//   //this function will find the directory to place the downloaded file
//   Future<Directory> _getDownloadDirectory() async {
//     Directory _directory;
//     if (Platform.isAndroid && await _requestStoragePermission()) {
//       // Use external storage _directory on Android
//       _directory = Directory('/storage/emulated/0/Download');
//       if (!await _directory.exists()) {
//         _directory = await getExternalStorageDirectory() ??
//             await getApplicationDocumentsDirectory();
//       }
//     } else if (Platform.isIOS) {
//       // Use documents _directory on iOS
//       _directory = await getApplicationDocumentsDirectory();
//     } else {
//       // Use downloads _directory on desktop platforms
//       _directory = await getDownloadsDirectory() ??
//           await getApplicationDocumentsDirectory();
//     }
//     return _directory;
//   }
//
//   Future<bool> _requestStoragePermission() async {
//     if (Platform.isAndroid) {
//       if (await Permission.manageExternalStorage.isGranted ||
//           await Permission.manageExternalStorage.request().isGranted) {
//         // final status = await Permission.storage.request();
//         final status = await Permission.manageExternalStorage.request();
//         return status.isGranted;
//
//         ///**TODO: need to test this status later
//         // if (status.isDenied) {
//         //   return false;
//         // }
//         ///*******************************************
//       }
//       // For Android 9 and below
//       else if (await Permission.storage.isGranted ||
//           await Permission.storage.request().isGranted) {
//         // Permission granted
//         return true;
//       } else {
//         return false;
//       }
//     }
//     return false;
//   }
// }
