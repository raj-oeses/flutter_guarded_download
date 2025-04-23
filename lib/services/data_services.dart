import 'package:flutter_guarded_download/downloader/file_downloader_interface.dart';
import 'package:flutter_guarded_download/enums/method_enum.dart';
import 'package:http/http.dart' as http;

class DataServices {
  // File Download
  static Future<dynamic> fileDownload(String downloadUrl,
      {String? token,
      DownloadMethod method = DownloadMethod.GET,
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

      final request = http.Request(
          method == DownloadMethod.GET ? 'GET' : 'POST',
          Uri.parse(downloadUrl));
      request.headers.addAll(_headers);

      //
      final http.StreamedResponse response = await request.send();

      return response;
    } catch (error) {
      return onError?.call('Exception in download: $error');
    }
  }
}
