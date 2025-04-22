import 'package:flutter/material.dart';
import 'package:flutter_guarded_download/debug_print/debug_printer.dart';
import 'package:flutter_guarded_download/downloader/file_downloader.dart';
import 'package:flutter_guarded_download/downloader/file_downloader_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _downloader = FileDownloader();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                onPressed: () async {
                  print(':::::::::::::we are pressing::::::::::::');
                  final url =
                      "https://fmpartnerdev.azurewebsites.net/api/admin/Report/GetPaymentReport/Download?startDate=2025-03-22&endDate=2025-04-21&vendorId=516&showAll=1&userId=8014";

                  await _downloader.downloadFile(
                    downloadUrl: url,
                    fileName: "invoice_report.xlsx",
                    token: _token,
                    method: DownloadMethod.POST,
                    onProgress: (receivedBytes, totalBytes) {
                      DebugPrinter.info(
                          '::::::::::onProgress::${totalBytes > 0 ? receivedBytes / totalBytes : 0}');
                    },
                    onCompleted: (path) {
                      DebugPrinter.info('::::::::::onCompleted::$path');
                    },
                    onError: (error) {
                      DebugPrinter.info('::::::::::error::$error');
                    },
                  );
                },
                child: Text("Download"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

const String _token =
    "eyJhbGciOiJSUzI1NiIsImtpZCI6IkQyRjU0Mjg0NDMxQTY2ODEwQ0RFODAwODQwMjU2NjYzIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE3NDUzMTQzNzYsImV4cCI6MTc0NTMxNDc5NiwiaXNzIjoiaHR0cHM6Ly9mbXBhcnRuZXJkZXYuYXp1cmV3ZWJzaXRlcy5uZXQvb2F1dGgiLCJhdWQiOlsiRk1SZXN0cm9BcGkiLCJodHRwczovL2ZtcGFydG5lcmRldi5henVyZXdlYnNpdGVzLm5ldC9vYXV0aC9yZXNvdXJjZXMiXSwiY2xpZW50X2lkIjoiZmx1dHRlcl9jbGlfcm8iLCJzdWIiOiI4MzY1IiwiYXV0aF90aW1lIjoxNzQ1MzE0Mzc2LCJpZHAiOiJsb2NhbCIsImZ1bGxOYW1lIjoiYWEgYWEgYWEgYWEiLCJwaG9uZU51bWJlciI6Ijc3ODg5OTY2NTUiLCJyb2xlIjpbIlVzZXIiLCJTdG9yZV9BZG1pbiIsIlN0b3JlX1N1cGVydmlzb3IiLCJQYXJ0bmVyVmVuZG9yX0FkbWluIl0sInNzIjoic2NPU3RMcHZKWEpBZjhkdHJPZTBlZ1NOWXVKeG9uQnpFNTZHcms4eDlBeno1d293QTBYbHpRIiwiZGV2aWNlX3V1aWQiOiJjNmE4YTZlNy03MzM4LTRiZDAtODBiNC0wMWI3NThjODFkZjgiLCJhbXJfZm0iOiJwd2QiLCJlbWFpbCI6ImFhYWFAZ21haWwuY29tIiwicHJvbXB0TG9nb3V0IjoiRmFsc2UiLCJqdGkiOiJGOTg2NkY1QzJCRkNFREM1MDJEM0ZEMzE4RDYzODBBOCIsImlhdCI6MTc0NTMxNDM3Niwic2NvcGUiOlsiYXBpX3Jlc3RybyIsIklkZW50aXR5U2VydmVyQXBpIiwib2ZmbGluZV9hY2Nlc3MiXSwiYW1yIjpbInB3ZCJdfQ.ItXz5jasGlWlyTMmPjWKZvV1dRdZ6BU_swZFv_iI7ELTjqFmwbon5OGIUXHF9z5gg_E0A6_9dHjf-SwgaJK4g65Ig6Oj-I_JYMX9TOxF_qu1tiULiOU02svXXvLPSMoQu6dKqlJAq6AyAZ4AjtqPHQOuZt7xDEoDMm5Rg4sBNIrWqxfBKoShL-hBUsUx8BvPDONequFVFYLnQzzQyC02N-qh_dEAdHJNq6-aJ5x4FbssBgcHPl2Vg9UmouioKCOO7GNXzCZcZ_GL5sYDiMTyYnc9ehiDe_wgW3JYJ3Vty7O7uHEOMZSvf0MtzK_wHRmsRUNTKfJ4F9OZm8UouzoD3A";
