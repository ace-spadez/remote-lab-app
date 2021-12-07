import 'dart:async';
import 'dart:math';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remote_lab_app/api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final Random random = Random();

class ExperimentView extends StatefulWidget {
  ExperimentView({Key? key}) : super(key: key);

  @override
  _ExperimentViewState createState() => _ExperimentViewState();
}

class _ExperimentViewState extends State<ExperimentView> {
  _ExperimentViewState() {
    timer =
        Timer.periodic(const Duration(milliseconds: 2000), _updateDataSource);
    cummulativeList = [...chartData];
  }
  bool _loading = false;
  API api = API();
  bool _connected = false;
  int _count = 10;
  int _currentValue = 100;
  int _dutyCycle = 100;
  List<String> variables = ["Voltage", "Current", "RPM"];
  List<String> variablesUnits = ["V", "mA", "rpm"];

  List<Color> varColors = [Colors.blue,Colors.red,Colors.green];
  bool _loadingAttunement = false;
  ChartData? attunement;
  Timer? timer;
  List<ChartData> chartData = List<ChartData>.generate(
      0,
      (i) => ChartData(list: [
            i + 2 + random.nextDouble() - 0.5,
            10 * (i + 2 + random.nextDouble() - 0.5),
            3 * (i + 2 + random.nextDouble() - 0.5)
          ], time: 200.0 + 2 * i, t: DateTime.now()));
  List<ChartData>? cummulativeList;

  List<ChartSeriesController?> _listCSC =
      List<ChartSeriesController?>.generate(3, (i) => null);

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _updateDataSource(Timer timer) async {
    ChartData cd = await api.getEnvData();
    List<ChartData> nl = [...cummulativeList ?? [], cd];
    nl.sort((a, b) => (a.list?[0] ?? 0).compareTo(b.list?[0] ?? 0));
    chartData.add(cd);
    setState(() {
      cummulativeList = [...nl];
    });

    if (chartData.length == 11) {
      chartData.removeAt(0);
      for (int i = 0; i < 3; i++) {
        _listCSC[i]?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
          removedDataIndexes: <int>[0],
        );
      }
    } else {
      for (int i = 0; i < 3; i++) {
        _listCSC[i]?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
        );
      }
    }
    _count = _count + 1;
  }

  SfCartesianChart _buildLiveLineChart(int index) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            title: AxisTitle(
              text: index == 0
                  ? "voltage"
                  : index == 1
                      ? "current"
                      : "rpm",
              textStyle: GoogleFonts.b612(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  decoration: TextDecoration.none),
            ),
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0)),
        series: <LineSeries<ChartData, DateTime>>[
          LineSeries<ChartData, DateTime>(
            onRendererCreated: (ChartSeriesController controller) {
              _listCSC[index] = controller;
              // _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: varColors[index],
            xValueMapper: (ChartData item, _) => item.t,
            yValueMapper: (ChartData item, _) => item.list?[index],
            animationDuration: 0,
          )
        ]);
  }

  SfCartesianChart _buildGraph(int index) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
            title: AxisTitle(
          text: 'Voltage(V)',
          textStyle: GoogleFonts.b612(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              decoration: TextDecoration.none),
        )),
        primaryYAxis: CategoryAxis(
            title: AxisTitle(
          text: index == 0 ? 'Current(mA)' : 'rpm',
          textStyle: GoogleFonts.b612(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              decoration: TextDecoration.none),
        )),
        // primaryXAxis: ,
        series: <ChartSeries>[
          LineSeries<ChartData, double>(
            dataSource: cummulativeList ?? [],
            // dashArray: <double>[5, 5],
            xValueMapper: (ChartData item, _) => item.list?[0],
            yValueMapper: (ChartData item, _) => item.list?[index + 1],
          )
        ]);
  }

  @override
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
                await api.startExperiment();

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
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text('Measuring the rpm of a motor using an  IR sensor',
                    style: GoogleFonts.b612(fontWeight: FontWeight.bold,fontSize: 20)),
              ),
              Container(
                child: Text(
                    'Using an IR sensor, we measure the  speed of  the motor and plot RPM vs Voltage  and RPM vs current graphs',
                    style: GoogleFonts.b612()),
              ),
              Container(

                margin: EdgeInsets.only(top:20,),
                child: Row(
                  children: [
                    for (int i in [0, 1, 2])
                      Container(
                        margin: EdgeInsets.only(right:20),
                          child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right:5),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: varColors[i],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          Text(variables[i],
                          style: GoogleFonts.b612(
                            fontWeight:FontWeight.bold
                          ),
                          ),
                        ],
                      ),
                      )
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Spacer(),
                    NumberPicker(
                      value: _currentValue,
                      minValue: 0,
                      maxValue: 255,
                      onChanged: (value) =>
                          setState(() => _currentValue = value),
                    ),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(!_connected
                              ? Colors.grey
                              : _loadingAttunement
                                  ? Colors.grey
                                  : Colors.blueAccent),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                            left: 20,
                            right: 20,
                          )),
                          elevation: MaterialStateProperty.all(1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            // side: BorderSide(color: Colors.red),
                          )),
                        ),
                        onPressed: () async {
                          var val =  _currentValue;

                          if (!_connected) return;
                          setState(() {
                            _loadingAttunement = true;


                          });
                          ChartData cd =
                              await api.attuneDutyCycle(_currentValue);
                          setState(() {
                            _loadingAttunement = false;
                            _dutyCycle = val;

                            attunement = cd;
                          });
                        },
                        child: _loadingAttunement
                            ? Container(
                                width: 20,
                                height: 20,
                                margin: EdgeInsets.only(left: 30, right: 30),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                _connected
                                    ? 'Attune Duty Cycle'
                                    : 'Connect to attune',
                                style: GoogleFonts.b612(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ))),
                    Spacer(),
                  ],
                ),
              ),
              attunement==null?Container():
              Container(
                child: Column(
                  children: [
                     Container(
                        margin: EdgeInsets.only(right:20,top:5),
                          child: Row(
                        children: [
                        
                          Text("Attunement duty cycle "+_dutyCycle.toString() ,
                          style: GoogleFonts.b612(
                            // fontWeight:FontWeight.bold
                          ),
                          ),
                        ],
                      ),
                      ),
   for (int i in [0, 1, 2])
                      Container(
                        margin: EdgeInsets.only(right:20,top:5),
                          child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right:5),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: varColors[i],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          Text("Attuned "+variables[i] +" "+((attunement?.list?[i])??0.0).toStringAsFixed(3)+variablesUnits[i],
                          style: GoogleFonts.b612(
                            // fontWeight:FontWeight.bold
                          ),
                          ),
                        ],
                      ),
                      )
                  ],
                ),
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
                        child: _connected
                            ? Container(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10, right: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Text(
                                      "Drag down to close",
                                      style: GoogleFonts.b612(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          decoration: TextDecoration.none),
                                    ),
                                    _buildGraph(0),
                                    _buildGraph(1)
                                  ],
                                ))
                            : Container(
                                padding: EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Please Connect to the remote lab first',
                                  style: GoogleFonts.b612(
                                      color: Colors.black,
                                      fontSize: 10,
                                      decoration: TextDecoration.none),
                                )),
                      ),
                    );
                  },
                  child: Icon(Icons.graphic_eq)),
              label: ''),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: _connected
                            ? Container(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10, right: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Drag down to close",
                                        style: GoogleFonts.b612(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            decoration: TextDecoration.none),
                                      ),
                                      _buildLiveLineChart(0),
                                      _buildLiveLineChart(1),
                                      _buildLiveLineChart(2),
                                    ],
                                  ),
                                ))
                            : Container(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Please Connect to the remote lab first',
                                  style: GoogleFonts.b612(
                                      color: Colors.black,
                                      fontSize: 10,
                                      decoration: TextDecoration.none),
                                )),
                      ),
                    );
                  },
                  child: Icon(Icons.ac_unit)),
              label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }
}
