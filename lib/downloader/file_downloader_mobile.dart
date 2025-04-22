import 'dart:io';

import 'package:flutter_guarded_download/enums/method_enum.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_downloader_interface.dart';

///Instance
FileDownloaderInterface getInstance() => MobileFileDownloader();

/// Mobile implementation of FileDownloaderInterface
class MobileFileDownloader implements FileDownloaderInterface {
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
      // Request storage permission on Android
      final directory = await _getDownloadDirectory();

      //Path of the file
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // await DataAccessService.fileDownload(downloadUrl, file);
      await _downloadWithGet(downloadUrl, file,
          token: token,
          onProgress: onProgress,
          onCompleted: onCompleted,
          onError: onError);
    } catch (e) {
      onError?.call('Error downloading file: $e');
    }
  }

  @override
  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted ||
          await Permission.manageExternalStorage.request().isGranted) {
        // if permission is granted
        return await Permission.manageExternalStorage.request().isGranted;
      }

      // For Android 9 and below
      else if (await Permission.storage.isGranted ||
          await Permission.storage.request().isGranted) {
        // Permission granted
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<Directory> _getDownloadDirectory() async {
    Directory _directory;
    if (Platform.isAndroid && await checkPermission()) {
      // Use external storage _directory on Android
      _directory = Directory('/storage/emulated/0/Download');
      if (!await _directory.exists()) {
        _directory = await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      }
    } else if (Platform.isIOS) {
      // Use documents _directory on iOS
      _directory = await getApplicationDocumentsDirectory();
    } else {
      // Use downloads _directory on desktop platforms
      _directory = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }
    return _directory;
  }

  Future<void> _downloadWithGet(String url, File file,
      {String? token,
      DownloadMethod method = DownloadMethod.GET,
      ProgressCallback? onProgress,
      CompletedCallback? onCompleted,
      ErrorCallback? onError}) async {
    try {
      //Add headers
      Map<String, String> _headers = <String, String>{
        'Content-Type': 'application/json'
      };

      //Ask For authorization
      if (token != null) {
        _headers['Authorization'] = 'Bearer $token';
      }

      //Request to server
      final request = http.Request(
          method == DownloadMethod.GET ? "GET" : 'POST', Uri.parse(url));
      request.headers.addAll(_headers);

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
}
