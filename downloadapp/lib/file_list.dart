import 'dart:io';
import 'package:dio/dio.dart';

import '../check_permission.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'directory_path.dart';

class FileList extends StatefulWidget {
  const FileList({super.key});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  bool isPermission = false;
  CheckPermission checkAllPermission = CheckPermission();

  checkPermission() async {
    bool permission = await checkAllPermission.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  var dataList = [
    {
      "id": "2",
      "title": "file Mp3 shankiti",
      "url": "https://www.shanqiti.com/lesson2021/maqatie/fiqhalbuyue.mp3"
    },
    {
      "id": "3",
      "title": "file shanqiti 2",
      "url": "https://www.shanqiti.com/lesson2021/almuhadarat/10.mp3"
    },
    {
      "id": "4",
      "title": "file Video 3",
      "url": "https://download.samplelib.com/mp4/sa..."
    },
    {
      "id": "5",
      "title": "file Video 4",
      "url": "https://download.samplelib.com/mp4/sa..."
    },
    {
      "id": "6",
      "title": "file PDF 6",
      "url": "https://www.iso.org/files/live/sites/..."
    },
    {
      "id": "10",
      "title": "file PDF 7",
      "url": "https://www.tutorialspoint.com/javasc..."
    },
    {
      "id": "10",
      "title": "C++ Tutorial",
      "url": "https://www.tutorialspoint.com/cplusp..."
    },
    {
      "id": "11",
      "title": "file PDF 9",
      "url": "https://www.iso.org/files/live/sites/..."
    },
    {
      "id": "12",
      "title": "file PDF 10",
      "url": "https://www.tutorialspoint.com/java/j..."
    },
    {
      "id": "13",
      "title": "file PDF 12",
      "url": "https://www.irs.gov/pub/irs-pdf/p463.pdf"
    },
    {
      "id": "14",
      "title": "file PDF 11",
      "url": "https://www.tutorialspoint.com/css/cs..."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isPermission
          ? ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                var data = dataList[index];
                return TileList(
                  fileUrl: data['url']!,
                  title: data['title']!,
                );
              },
            )
          : Center(
              child: TextButton(
                onPressed: () {
                  print(isPermission);
                  checkPermission();
                },
                child: const Text('permission issue'),
              ),
            ),
    );
  }
}

class TileList extends StatefulWidget {
  const TileList({
    super.key,
    required this.fileUrl,
    required this.title,
  });
  final String fileUrl;
  final String title;

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = '';
  late String filePath;
  late CancelToken cancelToken;

  var getPathFile = DirectoryPath();

  startDownload() async {
    print('start1');
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    print(filePath);
    try {
      setState(() {
        dowloading = true;
      });
      print('try true');
      await Dio().download(widget.fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
      });
    } catch (e) {
      print('catch true');
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = path.basename(widget.fileUrl);
    });
    checkFileExit();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.grey,
      child: ListTile(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            fileExists && dowloading == false
                ? print('exit')
                : cancelDownload();
          },
          icon: fileExists && dowloading == false
              ? const Icon(
                  Icons.window,
                  color: Colors.green,
                )
              : const Icon(Icons.close),
        ),
        trailing: IconButton(
          onPressed: () {
            print('download');
            fileExists && dowloading == false ? print('exit') : startDownload();
          },
          icon: fileExists
              ? const Icon(
                  Icons.save,
                  color: Colors.green,
                )
              : dowloading
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        Text(
                          (progress * 100).toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : const Icon(Icons.download),
        ),
      ),
    );
  }
}
