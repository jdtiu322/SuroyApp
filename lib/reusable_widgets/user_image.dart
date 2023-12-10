import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserImage extends StatefulWidget {
  final Function(String imageUrl) onFileChanged;

  const UserImage({super.key, required this.onFileChanged});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final ImagePicker _picker = ImagePicker();

  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl == null) SvgPicture.asset('assets/vectors/add-image.svg', height: 150, width: 100,),
        if (imageUrl != null)
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _selectedPhoto(), 
            child: Image.network(
              imageUrl!, 
              width: 350,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        InkWell(
          onTap: () => _selectedPhoto(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              imageUrl != null ? 'Change Photo' : 'Select photo',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Future _selectedPhoto() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
            onClosing: () {},
            builder: (context) => Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('Camera'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.filter),
                      title: const Text('Pick a file'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.gallery);
                      },
                    )
                  ],
                )));
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) {
      return;
    }

    await _uploadFile(pickedFile.path);
  }

  Future _uploadFile(String filePath) async {
    String vImageFileName =
        "${DateTime.now().millisecondsSinceEpoch}.png";

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceImageDir = referenceRoot.child('vehicleImages');
    Reference referenceImageToUpload = referenceImageDir.child(vImageFileName);

    try {
     await referenceImageToUpload.putFile(File(filePath));
      // Get the download URL after the file is uploaded
      final fileUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        imageUrl = fileUrl;
      });

      widget.onFileChanged(fileUrl);
    } catch (error) {
      // Handle any potential errors during the upload.
      print("Error uploading file: $error");
    }
  }
}