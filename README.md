# Flutter Guarded Download

A Flutter package for downloading files on both web and mobile platforms with progress tracking and error handling.

## Features

- Download files on both web and mobile platforms
- Support for both GET and POST methods
- Progress tracking
- Error handling
- Permission handling for Android and iOS
- Authentication via token
- Custom file naming

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_file_downloader: ^0.1.0
```

Then run:

```bash
flutter pub get
```

### Android Setup

For Android, you need to add the following permissions to your `AndroidManifest.xml` file:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

For Android 10 (API level 29) and above, add the following to your `AndroidManifest.xml` file:

```xml
<application
    android:requestLegacyExternalStorage="true"
    ...
>
```

### iOS Setup

No additional setup is required for iOS.

## Usage

### Basic Usage

```dart
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

// Create an instance of FileDownloader
final downloader = FileDownloader();

// Download a file
await downloader.downloadFile(
  downloadUrl: 'https://example.com/file.pdf',
);
```

### Advanced Usage

```dart
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

// Create an instance of FileDownloader
final downloader = FileDownloader();

// Download a file with all options
await downloader.downloadFile(
  downloadUrl: 'https://example.com/secure-file.pdf',
  fileName: 'my_custom_file_name.pdf',
  token: 'your-auth-token',
  method: DownloadMethod.POST,
  onProgress: (receivedBytes, totalBytes) {
    // Calculate progress percentage
    final progress = (receivedBytes / totalBytes) * 100;
    print('Download progress: $progress%');
  },
  onCompleted: (filePath) {
    print('File downloaded to: $filePath');
  },
  onError: (error) {
    print('Error downloading file: $error');
  },
);
```

### Checking and Requesting Permissions

```dart
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

final downloader = FileDownloader();

// Check if permission is granted
final hasPermission = await downloader.checkPermission();

if (!hasPermission) {
  // Request permission
  final permissionGranted = await downloader.requestPermission();
  
  if (permissionGranted) {
    print('Permission granted');
  } else {
    print('Permission denied');
  }
}
```

## Example App

```dart
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DownloadExample(),
    );
  }
}

class DownloadExample extends StatefulWidget {
  @override
  _DownloadExampleState createState() => _DownloadExampleState();
}

class _DownloadExampleState extends State<DownloadExample> {
  final downloader = FileDownloader();
  double _progress = 0;
  String _status = '';

  void _downloadFile() async {
    setState(() {
      _status = 'Starting download...';
      _progress = 0;
    });

    await downloader.downloadFile(
      downloadUrl: 'https://example.com/sample.pdf',
      fileName: 'sample.pdf',
      onProgress: (receivedBytes, totalBytes) {
        setState(() {
          _progress = totalBytes > 0 ? receivedBytes / totalBytes : 0;
        });
      },
      onCompleted: (path) {
        setState(() {
          _status = 'File downloaded to: $path';
        });
      },
      onError: (error) {
        setState(() {
          _status = 'Error: $error';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Downloader Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _downloadFile,
              child: Text('Download File'),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(value: _progress),
            SizedBox(height: 10),
            Text('Progress: ${(_progress * 100).toStringAsFixed(1)}%'),
            SizedBox(height: 20),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.