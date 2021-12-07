import 'dart:math';

import 'package:remote_lab_app/data.dart';
const bool deployed = false;

class ChartData {
  double? time;
  DateTime? t;

  List<double>? list;

  ChartData({this.list, this.time, this.t});
}

class API {
  String? addr;
  Random random = Random();
  int count = 0;
  Data data  = Data();
  API({this.addr});

  Future<ChartData> getEnvData() async {

    await Future.delayed(Duration(seconds: 1));
    count++;
    return data.getAChartData(count);
  }

  Future<bool> getApparatusStatus() async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Future<bool> startExperiment()async{
    await Future.delayed(Duration(seconds: 5));
    return true;

  }

  Future<ChartData> attuneDutyCycle(int dutycycle)async{
    await Future.delayed(Duration(seconds: 5));
    count++;
    return data.getAChartData(count);
  }
}
