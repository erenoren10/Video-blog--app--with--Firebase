import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storagedeneme/anasayfa.dart';
import 'package:storagedeneme/profilsayfasi.dart';
import 'package:storagedeneme/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          iconTheme: IconThemeData(color: Colors.cyan),
          appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.light),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.cyan)))),
      routes: <String, WidgetBuilder>{
        '/Iskele': (BuildContext context) => Iskele()
      },
      home: Splash(),
    );
  }
}

class Iskele extends StatefulWidget {
  const Iskele({super.key});

  @override
  State<Iskele> createState() => _IskeleState();
}

class _IskeleState extends State<Iskele> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  Future<void> kayitOl() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      FirebaseFirestore.instance.collection("kullanicilar").doc(t1.text).set({
        "kullaniciEposta": t1.text,
        "kullaniciSifre": t2.text
      }).whenComplete(() => Future.sync(() => showDialog(
          context: context,
          builder: (BuildContext) {
            return AlertDialog(
                title: Text("BAŞARILI"),
                content: Text("Mail ve Şifreniz kaydedilmiştir"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("kapat")),
                ]);
          })));
    });
  }

  girisYap() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Anasayfa()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş yap / Kaydol"),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(30.0, 250.0, 30, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: ("e-mail giriniz."),
                  labelStyle: TextStyle(color: Colors.white, fontSize: (20)),
                  hintText: ("...@gmail.com"),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(76, 255, 255, 255)),
                ),
                controller: t1,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Şifre giriniz.",
                  labelStyle: TextStyle(color: Colors.white, fontSize: (20)),
                ),
                controller: t2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 88,
                      child: ElevatedButton(
                          onPressed: kayitOl, child: Text("Kaydol"))),
                  ElevatedButton(onPressed: girisYap, child: Text("Giriş Yap")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
