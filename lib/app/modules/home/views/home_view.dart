import 'package:current_detecter/app/modules/home/views/compass.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'dart:math' as math;

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Magnetic Field Data:',),
      ),
      body: Center(
        child: Obx(() {
double rotation = math.atan2(controller.magneticFieldData.value.y, controller.magneticFieldData.value.x) * (180 / math.pi);

          // If rotation is negative, convert it to positive
          if (rotation < 0) {
            rotation += 360;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('X: ${controller.magneticFieldData.value.x}'),
                      Text('Y: ${controller.magneticFieldData.value.y}'),
                  Text('Z: ${controller.magneticFieldData.value.z}'),
                    ],
                  ),
                   SizedBox(
                    width: 120,
                    child: Compass(rotation: rotation)),
                ],
              ),
              
              SizedBox(height: 20),
              if (controller.isCurrentDetected.value)
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'Current Detected!',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      minX: 0,
                      maxX: 20, // Adjust based on how many data points you want to show
                      minY: -100, // Adjust based on expected range
                      maxY: 100, // Adjust based on expected range
                      lineBarsData: [
                        // X Axis Line
                        LineChartBarData(
                          spots: _getXSpots(),
                          isCurved: true,
                          color:controller.isCurrentDetected.value ? Colors.red : Colors.blue,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                        // Y Axis Line
                        LineChartBarData(
                          spots: _getYSpots(),
                          isCurved: true,
                          color: controller.isCurrentDetected.value ? Colors.red :Colors.green,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                        // Z Axis Line
                        LineChartBarData(
                          spots: _getZSpots(),
                          isCurved: true,
                          color: controller.isCurrentDetected.value ? Colors.red : Colors.purple,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                        // Red Threshold Line
                        LineChartBarData(
                          spots: _getThresholdSpots(),
                          isCurved: false, // A straight line for the threshold
                          color: Colors.orange,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          barWidth: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  List<FlSpot> _getXSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < controller.xValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), controller.xValues[i]));
    }
    return spots;
  }

  List<FlSpot> _getYSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < controller.yValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), controller.yValues[i]));
    }
    return spots;
  }

  List<FlSpot> _getZSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < controller.zValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), controller.zValues[i]));
    }
    return spots;
  }

  List<FlSpot> _getThresholdSpots() {
    List<FlSpot> spots = [];
    double thresholdValue = 50.0; // Example threshold
    for (int i = 0; i < 20; i++) {
      spots.add(FlSpot(i.toDouble(), thresholdValue));
    }
    return spots;
  }
}
