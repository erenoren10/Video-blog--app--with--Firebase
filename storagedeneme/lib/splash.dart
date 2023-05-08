import 'package:flutter/material.dart';
import 'package:storagedeneme/main.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/Iskele', (Route<dynamic> route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).iconTheme.color,
      body: Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Theme.of(context).colorScheme.background,
          size: 250,
        ),
      ),
    );
  }
}
