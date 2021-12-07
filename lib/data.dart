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

    
    return ChartData(list: [
      k,
      21.9 *k + 2*(random.nextDouble() - 0.5),
      19.9 *k+ 2*(random.nextDouble() - 0.5)
    ], time: 200.0 + 2 * count % 10, t: DateTime.now());
  }

  void writeToFile(){
    // var fl =  File('data.txt');
    // var  sink = fl.openWrite();
    for(int i=0;i<256;i++){
    double k =  5.0*i/255.0;
    var l=[
      k,
      21.9 *k + 2*(random.nextDouble() - 0.5),
      19.9 *k+ 2*(random.nextDouble() - 0.5)
    ];
    print("[$i,  ${l[0]}, ${l[1]}, ${l[2]}],");
      // sink.write(l.join(" ")+"\n");
      
    }
    // sink.close();
  }
}
