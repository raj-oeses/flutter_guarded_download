import 'package:flutter_guarded_download/debug_print/debug_printer.dart';
import 'package:flutter_guarded_download/enums/method_enum.dart';
import 'package:http/http.dart' as http;

class DataAccessService {
  // File Download
  static Future<http.StreamedResponse?>? fileDownload(String url,
      {String? token,MethodEnum? method}) async {
    print('We are in fileDownload::::::::::::::::');
    try {
      //Add headers
      Map<String, String> _headers = <String, String>{
        'Content-Type': 'application/json'
      };

      //Ask For authorization
      if (token != null) {
        _headers['Authorization'] = 'Bearer $token';
      }
      DebugPrinter.info('URL::--$url');

      // return http.Request('GET', Uri.parse(url)).send();
      final request = http.Request('POST', Uri.parse(url));
      request.headers.addAll(_headers);

      //
      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return response;
      }
    } catch (error) {
      print('Exception:::::::::$error');
      return await Future.value(null);
    }
    return await Future.value(null);
  }
}
