import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class FileManagementProvider extends StateNotifier<AsyncValue<int>> {
  // late externalStorageDirectory;
  FileManagementProvider() : super(AsyncValue.data(1)) {
    //  externalStorageDirectory =await  getExternalStorageDirectories()![0];
  }
  Future getFile(String path) async {
    state = AsyncValue.loading();
    try {
      var file = File(path);
      var isValid = await file.exists();
      if (isValid) {
        // print('${await file.exists()}');
        // print('Exists in getFile function in approve_requests');
        var encodedJson = await file.readAsString();
        print('This isthe enocde whiel getting fiile${encodedJson}');
        // print('Runtype of decoded file: ${json.decode(encodedJson).runtimeType}');
        state = AsyncValue.data(1);
        return json.decode(encodedJson);
      }
      state = AsyncValue.data(1);
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      return null;
    }
  }

  Future addFileExternalStorageDirectories(String path, String data) async {
    state = AsyncValue.loading();
    try {
      final directory = (await getExternalStorageDirectories())![0];
      final writeFile = await File('${directory.path}/${path}.txt').create(
        exclusive: false,
        recursive: true,
      );
      print('Adding directory is:${directory.path}/${path}.txt');
      // var encodedJson=json.encode()
      final writtenFile = await writeFile.writeAsString(data);
      state = AsyncValue.data(1);
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      return null;
    }
  }

  Future getFilesFromDirectory(String folderPath) async {
    print('Folder path:${folderPath}');
    // state = AsyncValue.loading();
    try {
      final lists = (await getExternalStorageDirectories())![0];
      // Directory('fdf').
      List<Future<dynamic>> consents = [];
      if (await Directory(lists.path + '${folderPath}').exists() == false) {
        return consents;
      }
      final directory = Directory(lists.path + '${folderPath}').listSync(
        recursive: true,
      );
      print('THis is the directory:${directory}');
      if (directory.isNotEmpty) {
        print('These are the non zero directories ${directory}');
        consents = directory.map((item) async {
          var fileData = await getFile(item.path);
          print('THis is the file data: ${fileData}');
          return fileData;
          // return file;
        }).toList();
        state = AsyncValue.data(1);
        return consents;
      }
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      return null;
    }
  }

  Future deleteFileExternalStorageDirectories(String path) async {
    try {
      final directory = (await getExternalStorageDirectories())![0];
      var file = File('${directory.path}${path}');
      if (await file.exists()) {
        file.delete(recursive: true);
      }
      state = AsyncValue.data(1);
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
    }
  }
}

final filemanagementNotifierProvider =
    StateNotifierProvider<FileManagementProvider, AsyncValue<int>>(
        (ref) => FileManagementProvider());
