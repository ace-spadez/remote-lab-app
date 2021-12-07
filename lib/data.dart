import 'dart:io';
import 'dart:math';

import 'package:remote_lab_app/api.dart';

class Data {
  Random random = Random();
  ChartData getAChartData(int count) {
    double k =  0.5*(count % 10+1)   - random.nextDouble()*0.5;
    return ChartData(list: [
      k,
      21.9 *k + 2*(random.nextDouble() - 0.5),
      19.9 *k+ 2*(random.nextDouble() - 0.5)
    ], time: 200.0 + 2 * count % 10, t: DateTime.now());
  }
  ChartData getAChartDataDutyCycle(int count,int  dutycycle) {
    double k =  5.0*dutycycle/255.0;

    print(
      """
      
      {
    "m2m:cnt": {
        "rn": "ENVIRONMENT",
        "ty": 3,
        "ri": "/in-cse/cnt-6637425",
        "pi": "/in-cse/CAE138724499",
        "ct": "20211207T172459",
        "lt": "20211207T172459",
        "lbl": [
            "current",
            "dutycycle",
            "rpm",
            "status",
            "voltage"
        ],
        "acpi": [
            "/in-cse/acp-516227225",
            "/in-cse/acp-454613824"
        ],
        "et": "20221207T172459",
        "st": 291,
        "mni": 2000,
        "mbs": 10000,
        "mia": 0,
        "cni": 291,
        "cbs": 316,
        "m2m:cin": [
            {
                "rn": "cin_685555356",
                "ty": 4,
                "ri": "/in-cse/cin-685555356",
                "pi": "/in-cse/cnt-6637425",
                "ct": "20211207T192757",
                "lt": "20211207T192757",
                "lbl": [
                    "Laba",
                    "Labe"
                ],
                "st": 0,
                "cnf": "text/plain:0",
                "cs": 6,
                "con": "asdasd"
            },
      """
    );
    return ChartData(list: [
      k,
      21.9 *k + 2*(random.nextDouble() - 0.5),
      19.9 *k+ 2*(random.nextDouble() - 0.5)
    ], time: 200.0 + 2 * count % 10, t: DateTime.now());
  }

  // void writeToFile(){
  //   // var fl =  File('data.txt');
  //   // var  sink = fl.openWrite();
  //   for(int i=0;i<256;i++){
  //   double k =  5.0*i/255.0;
  //   var l=[
  //     k,
  //     21.9 *k + 2*(random.nextDouble() - 0.5),
  //     19.9 *k+ 2*(random.nextDouble() - 0.5)
  //   ];
  //   print("[$i,  ${l[0]}, ${l[1]}, ${l[2]}],");
  //     // sink.write(l.join(" ")+"\n");
      
  //   }
  //   // sink.close();
  // }
}
