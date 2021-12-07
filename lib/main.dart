import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_lab_app/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Remote Lab'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        leading: Image.asset('assets/logo.png'),
        backgroundColor: Colors.white,
        elevation: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: GoogleFonts.b612(
              color: Colors.deepPurple, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[
              Card(),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          const BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded), label: '')
        ],
      ),
    );
  }
}

class Card extends StatefulWidget {
  Card({Key? key}) : super(key: key);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Measuring the rpm of a motor using an  IR sensor',
              style: GoogleFonts.b612(fontWeight: FontWeight.bold)),
          Text(
              'Using an IR sensor, we measure the  speed of  the motor and plot RPM vs Voltage  and RPM vs current graphs',
              style: GoogleFonts.b612()),
          Container(
            width: 30,
            margin: EdgeInsets.only(top: 10),
            height: 30,
            child: GestureDetector(
              child: Image.asset('assets/enter.png'),
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>ExperimentView()),);
              },
            ),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
