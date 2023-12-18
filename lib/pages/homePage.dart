import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              Text('fair sales'),
            ],
          ),
        ),
      )),
    );
  }
}
