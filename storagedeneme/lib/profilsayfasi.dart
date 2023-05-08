import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storagedeneme/anasayfa.dart';
import 'package:storagedeneme/main.dart';
import 'package:storagedeneme/videoplayer.dart';
import 'package:storagedeneme/videoresim.dart';

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => Iskele()),
                    (Route<dynamic> route) => false);
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => VideoResim()),
                (Route<dynamic> route) => true);
          }),
      body: ProfilTasarimi(),
    );
  }
}

class ProfilTasarimi extends StatefulWidget {
  const ProfilTasarimi({super.key});

  @override
  State<ProfilTasarimi> createState() => _ProfilTasarimiState();
}

class _ProfilTasarimiState extends State<ProfilTasarimi> {
  late File yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  String indirmeBaglantisi = "";

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
  }

  baglantiAl() async {
    String baglanti = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilresmi.png")
        .getDownloadURL();
    setState(() {
      indirmeBaglantisi = baglanti;
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
        .child("profilresimleri")
        .child(auth.currentUser!.uid)
        .child("profilresmi.png");
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        ClipOval(
            child: indirmeBaglantisi.isNotEmpty
                ? Image.network(
                    indirmeBaglantisi,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Text("resim boş")),
        ElevatedButton(
          onPressed: kameradanYukle,
          child: Text("resim yükle"),
        )
      ]),
    );
  }
}


//
