import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoResim extends StatelessWidget {
  const VideoResim({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ButonEkrani(),
    );
  }
}

class ButonEkrani extends StatefulWidget {
  const ButonEkrani({super.key});

  @override
  State<ButonEkrani> createState() => _ButonEkraniState();
}

class _ButonEkraniState extends State<ButonEkrani> {
  late File yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  String indirmeBaglantisi = "";

  kameradanVideoYukle() async {
    var alinanDosya = await ImagePicker().pickVideo(source: ImageSource.camera);
    setState(() {
      if (alinanDosya != null) {
        yuklenecekDosya = File(alinanDosya.path);
      }
    });
    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("videolar")
        .child(auth.currentUser!.uid)
        .child("videom.mp4");
    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
    final imageUrl = await referansYol
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilresmi.png")
        .getDownloadURL();
    setState(() {
      indirmeBaglantisi = imageUrl;
    });
  }

  kameradanYukle() async {
    var alinanDosya = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if (alinanDosya != null) {
        yuklenecekDosya = File(alinanDosya.path);
      }
    });
    Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("Fotoğraflar")
        .child(auth.currentUser!.uid + ".jpg");
    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: Text("Video Yükle"), onPressed: kameradanVideoYukle),
            SizedBox(width: 10),
            ElevatedButton(
                child: Text("Resim yükle"), onPressed: kameradanYukle)
          ],
        ),
      ),
    );
  }
}
