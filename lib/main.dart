import 'package:flutter/material.dart';
import 'package:opak_fuar/db/dataBaseHelper.dart';
import 'package:opak_fuar/pages/homePage.dart';
import 'package:opak_fuar/pages/login.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dt = DatabaseHelper("opak1.db");
    Ctanim.db = await dt.database();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(title: '',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget currentContent = Denemewidget1();

  void degistir() {
    setState(() {
      currentContent = HomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Üst'),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              currentContent,
            ]),
          ),
          SliverToBoxAdapter(
            child: ElevatedButton(
              onPressed: degistir,
              child: Text('Değiştir'),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              color: Colors.blue,
              child: Center(
                child: Text('Alt'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Denemewidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: SizedBox(
        height: 400,
        child: Center(
          child: Text('1'),
        ),
      ),
    );
  }
}

class DenemeWidget2 extends StatefulWidget {
  @override
  State<DenemeWidget2> createState() => _DenemeWidget2State();
}

class _DenemeWidget2State extends State<DenemeWidget2> {
  int sayi = 0;
  void sayiArt() {
    setState(() {
      sayi++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.orange,
      child: Center(
        child: TextButton(
          onPressed: () {
            sayiArt();
          },
          child: Text("DENEME Sayi bas buraya = " + sayi.toString()),
        ),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
//asa
//degil

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
*/