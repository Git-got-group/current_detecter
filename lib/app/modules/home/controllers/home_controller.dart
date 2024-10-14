import 'package:current_detecter/app/data/field_data.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeController extends GetxController {
  var magneticFieldData = MagneticFieldData(x: 0, y: 0, z: 0).obs;
  var isCurrentDetected = false.obs;

  // Lists to hold recent values for graphing
  var xValues = <double>[].obs;
  var yValues = <double>[].obs;
  var zValues = <double>[].obs;
  
  // For storing significant changes
  var significantChangesX = <double>[].obs;
  var significantChangesY = <double>[].obs;
  var significantChangesZ = <double>[].obs;

  @override
  void onInit() {
    super.onInit();
    _listenToMagnetometer();
  }

  void _listenToMagnetometer() {
    magnetometerEvents.listen((MagnetometerEvent event) {
      magneticFieldData.value = MagneticFieldData(
        x: event.x,
        y: event.y,
        z: event.z,
      );

      // Add values to the lists for graphing
      if (xValues.length > 20) xValues.removeAt(0); // Keep the last 20 points
      if (yValues.length > 20) yValues.removeAt(0);
      if (zValues.length > 20) zValues.removeAt(0);
      xValues.add(event.x);
      yValues.add(event.y);
      zValues.add(event.z);

      // Detect current presence based on magnetic field anomaly
      isCurrentDetected.value = _detectCurrent(event);
      
      // Detect significant changes
      _detectSignificantChanges(event);
    });
  }

  bool _detectCurrent(MagnetometerEvent event) {
    return event.x.abs() > 40 || event.y.abs() > 40 || event.z.abs() > 40; // Adjust thresholds as needed
  }

  void _detectSignificantChanges(MagnetometerEvent event) {
    // Check for significant changes and store them
    if (event.x.abs() > 10) {
      significantChangesX.add(event.x);
      if (significantChangesX.length > 20) significantChangesX.removeAt(0); // Keep the last 20 points
    }
    if (event.y.abs() > 10) {
      significantChangesY.add(event.y);
      if (significantChangesY.length > 20) significantChangesY.removeAt(0); // Keep the last 20 points
    }
    if (event.z.abs() > 10) {
      significantChangesZ.add(event.z);
      if (significantChangesZ.length > 20) significantChangesZ.removeAt(0); // Keep the last 20 points
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
