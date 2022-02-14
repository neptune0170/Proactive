import 'dart:io';
import 'dart:typed_data';

//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "users";

class FileCloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FileCloudStorageService() {}

  Future<dynamic?> saveFileToStorage(
      String _userID, Uint8List file, String filename) async {
    try {
      Reference _ref = _storage.ref().child('Files/$_userID/${filename}');
      UploadTask _task = _ref.putData(
        file,
      );
      return await _task.then(
        (_result) => _result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
  }
}
