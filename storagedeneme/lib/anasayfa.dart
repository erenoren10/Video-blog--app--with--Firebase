import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storagedeneme/main.dart';
import 'package:storagedeneme/profilsayfasi.dart';
import 'package:storagedeneme/videoplayer.dart';
import 'package:storagedeneme/videoresim.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: TabBar(
              controller: _tabController,
              tabs: [Tab(text: "data1"), Tab(text: "data2")]),
        ),
        appBar: AppBar(
          title: Text("Anasayfa"),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            fotoGoster(),
            VideoApp(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            
            
              FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => VideoResim()),
                        (Route<dynamic> route) => true);
                  }),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                trailing: Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilEkrani()),
                      (Route<dynamic> route) => true);
                },
              ),
              ListTile(
                trailing: Icon(Icons.exit_to_app),
                title: const Text('çıkış'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => MyApp()),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class fotoGoster extends StatefulWidget {
  const fotoGoster({super.key});

  @override
  State<fotoGoster> createState() => _fotoGosterState();
}

class _fotoGosterState extends State<fotoGoster> {
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
        .child("Fotoğraflar")
        .child(auth.currentUser!.uid + ".jpg")
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
        .child("Fotoğraflar")
        .child(auth.currentUser!.uid + ".jpg");
    UploadTask yuklemeGorevi = referansYol.putFile(yuklenecekDosya);
    final imageUrl = await referansYol
        .child("Fotoğraflar")
        .child(auth.currentUser!.uid + ".jpg")
        .getDownloadURL();
    setState(() {
      indirmeBaglantisi = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: indirmeBaglantisi.isEmpty
          ? Text("resim boş")
          : Image.network(
              indirmeBaglantisi,
              fit: BoxFit.cover,
            ),
    );
  }
}
