import 'package:flutter/material.dart';
import 'package:flutter_guarded_download/downloader/file_downloader.dart';
import 'package:flutter_guarded_download/enums/method_enum.dart';

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
                  final url =
                      "https://fmpartnerdev.azurewebsites.net/api/admin/Report/GetPaymentReport/Download?startDate=2025-03-23&endDate=2025-04-22&vendorId=516&showAll=1&userId=8014";

                  await _downloader.downloadFile(
                    downloadUrl: url,
                    fileName: "invoice_report.xlsx",
                    token: _token,
                    method: DownloadMethod.GET,
                    onProgress: (receivedBytes, totalBytes) {
                      print(
                          '::::::::::onProgress::${totalBytes > 0 ? receivedBytes / totalBytes : 0}');
                    },
                    onCompleted: (path) {
                      print('::::::::::onCompleted::$path');
                    },
                    onError: (error) {
                      print('::::::::::error::$error');
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
    "eyJhbGciOiJSUzI1NiIsImtpZCI6IkQyRjU0Mjg0NDMxQTY2ODEwQ0RFODAwODQwMjU2NjYzIiwidHlwIjoiYXQrand0In0.eyJuYmYiOjE3NDUzMTk1NzQsImV4cCI6MTc0NTMxOTk5NCwiaXNzIjoiaHR0cHM6Ly9mbXBhcnRuZXJkZXYuYXp1cmV3ZWJzaXRlcy5uZXQvb2F1dGgiLCJhdWQiOlsiRk1SZXN0cm9BcGkiLCJodHRwczovL2ZtcGFydG5lcmRldi5henVyZXdlYnNpdGVzLm5ldC9vYXV0aC9yZXNvdXJjZXMiXSwiY2xpZW50X2lkIjoiZmx1dHRlcl9jbGlfcm8iLCJzdWIiOiI4MDE0IiwiYXV0aF90aW1lIjoxNzQ1MzE5NTc0LCJpZHAiOiJsb2NhbCIsImZ1bGxOYW1lIjoiRGVlcGFrIFJhaiIsInBob25lTnVtYmVyIjoiOTg0OTE3ODk5OCIsInJvbGUiOlsiU3VwZXJBZG1pbiIsIlVzZXIiLCJDU1JfSW5jaGFyZ2UiXSwic3MiOiIwTUZhNFFrR2dEUWk3ZnFHRDZtUm1NTG1GT3JXTDlOMVdEcy9lZHdpYnVKSUR2ZnB1Y0tiRVEiLCJkZXZpY2VfdXVpZCI6IjQxN2JkZjEzLTliYTgtNGZhYS05YzU4LWE5MjQzMzI5OGEyNSIsImFtcl9mbSI6InB3ZCIsImVtYWlsIjoiZGVlcGFrakBmb29kbWFuZHUuY29tIiwicHJvbXB0TG9nb3V0IjoiRmFsc2UiLCJqdGkiOiI2MkQ4RDdBMjdDQjQyMDZDRDJFNjc1RDkyODdCODI3MyIsImlhdCI6MTc0NTMxOTU3NCwic2NvcGUiOlsiYXBpX3Jlc3RybyIsIklkZW50aXR5U2VydmVyQXBpIiwib2ZmbGluZV9hY2Nlc3MiXSwiYW1yIjpbInB3ZCJdfQ.K6qEOrZEzc6Q2S2i5ZQRzY7YG47IKZyhrS29hLzO2TV87KKnHLQHmVAz75vGysKxCV-4XpkHrjYzXAp8TCNuwht9QryQ5t0pEeZ4YsSnNcQ_BHQrQNw6hDPSOP3rT8Emis6XsVq_MhJIiCoeK46cYJjAym1TekOTjYS8ObV_PLKgyo74hiTmPkqKXePc2lYNpytH71NZaNObALq_nh2Dj_OSTr46ylEGTLXbw5qnwyjdw3GohTIGlPEhyazUnMlmUOJopUsgzHZYXCnV4k7kSXBcpSBJd57c2kFfLJxqHKjfQtFefVjkuUGcZOeC8L1-OsCAPachXg359G3kfypyNQ";
