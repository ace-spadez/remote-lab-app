import 'dart:math';

import 'package:remote_lab_app/api.dart';

class Data {
  Random random = Random();
  ChartData getAChartData(int count) {
    return ChartData(list: [
      count % 10 + 2 + random.nextDouble() - 0.5,
      10 * (count % 10 + 2 + random.nextDouble() - 0.5),
      3 * (count % 10 + 2 + random.nextDouble() - 0.5)
    ], time: 200.0 + 2 * count % 10, t: DateTime.now());
  }
}
