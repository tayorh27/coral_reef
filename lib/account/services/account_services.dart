import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class AccountServices {
  AccountServices();

  Future<File> compressAndGetFile(File file) async {
    String key = FirebaseDatabase.instance.reference().push().key;
    File tempFile =
        new File('${(await getTemporaryDirectory()).path}/$key.jpeg');
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tempFile.path,
      quality: 70,
    );
    return result;
  }

  Future<String> uploadProfileImageToStorage(File _file) async {
    String key = FirebaseDatabase.instance.reference().push().key;
    String fileExt = _file.path.substring(_file.path.lastIndexOf(".") + 1);
    // print(fileExt);
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('profile-images')
        .child('$key.$fileExt');
    final UploadTask uploadTask = ref.putFile(_file);
    await uploadTask.whenComplete(() {});
    TaskSnapshot storageTaskSnapshot = uploadTask.snapshot;
    return await storageTaskSnapshot.ref.getDownloadURL();
  }
}
