// example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_guarded_download/downloader/file_downloader.dart';
import 'package:flutter_guarded_download/enums/method_enum.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Downloader Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DownloadPage(),
    );
  }
}

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final _downloader = FileDownloader();
  final _urlController = TextEditingController();
  final _tokenController = TextEditingController();
  final _fileNameController = TextEditingController();

  DownloadMethod _method = DownloadMethod.GET;
  double _progress = 0;
  String _status = 'Ready to download';
  bool _isDownloading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _tokenController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  Future<void> _startDownload() async {
    if (_urlController.text.isEmpty) {
      setState(() {
        _status = 'Please enter a URL';
      });
      return;
    }

    setState(() {
      _isDownloading = true;
      _progress = 0;
      _status = 'Starting download...';
    });

    try {
      // Check permission first
      bool hasPermission = await _downloader.checkPermission();
      if (!hasPermission) {
        setState(() {
          _status = 'Requesting permission...';
        });

        setState(() {
          _status = 'Permission denied';
          _isDownloading = false;
        });
      }

      // Start the download
      await _downloader.downloadFile(
        downloadUrl: _urlController.text,
        fileName: _fileNameController.text.isNotEmpty
            ? _fileNameController.text
            : null,
        token: _tokenController.text.isNotEmpty ? _tokenController.text : null,
        method: _method,
        onProgress: (receivedBytes, totalBytes) {
          setState(() {
            if (totalBytes > 0) {
              _progress = receivedBytes / totalBytes;
              _status = 'Downloading: ${(_progress * 100).toStringAsFixed(1)}%';
            } else {
              _status = 'Downloading...';
            }
          });
        },
        onCompleted: (filePath) {
          setState(() {
            _status = 'Downloaded to: $filePath';
            _isDownloading = false;
            _progress = 1.0;
          });
        },
        onError: (error) {
          setState(() {
            _status = 'Error: $error';
            _isDownloading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Downloader Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Download URL',
                hintText: 'https://example.com/file.pdf',
              ),
              enabled: !_isDownloading,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fileNameController,
              decoration: const InputDecoration(
                labelText: 'File Name (Optional)',
                hintText: 'example.pdf',
              ),
              enabled: !_isDownloading,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Auth Token (Optional)',
                hintText: 'Bearer token',
              ),
              enabled: !_isDownloading,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Method: '),
                Radio<DownloadMethod>(
                  value: DownloadMethod.GET,
                  groupValue: _method,
                  onChanged: _isDownloading
                      ? null
                      : (value) {
                          setState(() {
                            _method = value!;
                          });
                        },
                ),
                const Text('GET'),
                Radio<DownloadMethod>(
                  value: DownloadMethod.POST,
                  groupValue: _method,
                  onChanged: _isDownloading
                      ? null
                      : (value) {
                          setState(() {
                            _method = value!;
                          });
                        },
                ),
                const Text('POST'),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 10),
            Text(
              _status,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _isDownloading ? null : _startDownload,
                child:
                    Text(_isDownloading ? 'Downloading...' : 'Download File'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
