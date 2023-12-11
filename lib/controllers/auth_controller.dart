import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // UPLOADING IMAGE AND PICK IMAGE

  _uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('licenseImageUrl').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }

  // UPLOADING IMAGE AND PICK IMAGE ENDS HERE

  // FUNCTION TO CREATE NEW USER
  Future<String> registerRenter(
    String firstName,
    String middleName,
    String lastName,
    String age,
    String email,
    String password,
    String phoneNumber,
    String driverLicense,
    Uint8List? image,
    String fcmToken,
  ) async {
    String res = 'some error occurred';

    try {
      if (image != null) {
        // CREATE NEW USER IN FIREBASE AUTH
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String licenseImageUrl = await _uploadProfileImageToStorage(image);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'firstName': firstName,
          'middleName': middleName,
          'lastName': lastName,
          'age': age,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'licenseImageUrl': licenseImageUrl,
          'driverLicense': driverLicense,
          'approved': false,
          'userId': cred.user!.uid,
          'fcmToken': fcmToken,
        });

        res = 'success';
      } else {
        res = 'please Fields must be filled in';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // FUNCTION TO CREATE NEW USER ENDS HERE

  // FUNCTION TO LOGIN USER

  Future<String> loginUser(
    String email,
    String password,
  ) async {
    String res = 'some error occurred';

    try {
      // CREATE NEW USER IN FIREBASE AUTH
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
