import 'package:sensors/sensors.dart';
import '../models/gyroscope_model.dart';

class GyroscopeController {
  // Función para obtener los datos del giroscopio
  Stream<GyroscopeData> getGyroscopeData() {
    return gyroscopeEvents.map((event) {
      return GyroscopeData(x: event.x, y: event.y, z: event.z);
    });
  }
}
