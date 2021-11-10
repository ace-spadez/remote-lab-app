import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExperimentView extends StatefulWidget {
  ExperimentView({Key? key}) : super(key: key);

  @override
  _ExperimentViewState createState() => _ExperimentViewState();
}

class _ExperimentViewState extends State<ExperimentView> {
  @override
  bool _loading = false;
  bool _connected = false;

  List<List<double>> data = [
    [0,0,0],
    [1,11.1,9.3],
    [2,20.2,20-5],
    [3,29.9,30.5],
    [4,44,41],
    [5,49,56.5],

  ];

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        leading: Image.asset('assets/logo.png'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _loading = true;
                });
                await Future.delayed(Duration(seconds: 5));

                setState(() {
                  _connected = !_connected;
                  _loading = false;
                });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    _loading
                        ? Colors.white
                        : _connected
                            ? Colors.green
                            : Colors.black,
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(left: 20, right: 20),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    // side: BorderSide(color: Colors.red),
                  ))),
              child: Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                child: !_loading
                    ? Text(
                        _connected ? 'Connected' : 'Connect',
                        style: GoogleFonts.b612(),
                      )
                    : Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          )
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          margin: EdgeInsets.only(top:10),
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child:Text('Measuring the rpm of a motor using an  IR sensor',
              style: GoogleFonts.b612(fontWeight: FontWeight.bold)),
              ),
              Container(
                child: Text(
              'Using an IR sensor, we measure the  speed of  the motor and plot RPM vs Voltage  and RPM vs current graphs',
              style: GoogleFonts.b612()),
              ),
              Container(
                margin: EdgeInsets.only(top:20),
                child:Column(children: [
                  Container(
                    padding:EdgeInsets.only(top:5,bottom:5,right:30,left:30),
                    margin:EdgeInsets.only(top:5,bottom:5),
                    child: Text('Voltage (V)',style:GoogleFonts.b612(color:Colors.black)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black12),
                    // color: Colors.white24,
                  ),
                  Container(
                    padding:EdgeInsets.only(top:5,bottom:5,right:30,left:30),
                    margin:EdgeInsets.only(top:5,bottom:5),
                    child: Text('Current (mA)',style:GoogleFonts.b612(color:Colors.black)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black12),
                    // color: Colors.white24,
                  ),
                  Container(
                    padding:EdgeInsets.only(top:5,bottom:5,right:30,left:30),
                    margin:EdgeInsets.only(top:5,bottom:5),
                    child: Text('Speed (rpm)',style:GoogleFonts.b612(color:Colors.black)),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black12),
                    // color: Colors.white24,
                  )
                ],)
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        
                        controller: ModalScrollController.of(context),
                        child:_connected? Container(
                          padding: EdgeInsets.only(top:50,left:20,right:20),
                          height:  MediaQuery.of(context).size.height,
                          width:  MediaQuery.of(context).size.width,
                          child:Column(children: [
                            SfCartesianChart(
                              primaryXAxis:   CategoryAxis(
                                title: AxisTitle(text: 'Voltage(V)')
                              ),
                              primaryYAxis:   CategoryAxis(
                                title: AxisTitle(text: 'Current(mA)')
                              ),
                              // primaryXAxis: ,
                              series:  <ChartSeries>[
                                LineSeries<List<double>,double>(
                                  dataSource: data,
                                  dashArray: <double>[5, 5],
                                  xValueMapper: (List<double> item,_)=> item[0],
                                  yValueMapper: (List<double> item,_)=> item[1],
                    
                                )
                              ]
                            ),
                          SfCartesianChart(
                             primaryXAxis:   CategoryAxis(
                                title: AxisTitle(text: 'Voltage(V)')
                              ),
                              primaryYAxis:   CategoryAxis(
                                title: AxisTitle(text: 'Speed (rpm)')
                              ),
                              // primaryXAxis: ,
                              series:  <ChartSeries>[
                                LineSeries<List<double>,double>(
                                  dataSource: data,
                                  dashArray: <double>[5, 5],
                                  xValueMapper: (List<double> item,_)=> item[0],
                                  yValueMapper: (List<double> item,_)=> item[2],
                                )
                              ]
                            ),
                          ],)
                        ):Container(
                                                    padding: EdgeInsets.only(top:50,left:20,right:20),
                          height:  MediaQuery.of(context).size.height,
                          width:  MediaQuery.of(context).size.width,
                          alignment: Alignment.topCenter,
                          child:Text('Please Connect to the remote lab first',style: GoogleFonts.b612(
                            color:Colors.black,
                            fontSize:12,

                          ),)
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.graphic_eq)),
              label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: '',),
        ],
      ),
    );
  }
}
