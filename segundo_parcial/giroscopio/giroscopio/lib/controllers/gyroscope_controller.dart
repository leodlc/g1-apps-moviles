import 'package:sensors_plus/sensors_plus.dart';
import '../models/gyroscope_model.dart';

class GyroscopeController {
  Stream<GyroscopeData> getGyroscopeData() {
    return gyroscopeEvents.map((GyroscopeEvent event) {
      /* print(
          'Eje X: ${event.x}, Eje Y: ${event.y}, Eje Z: ${event.z}'); */ // Depuración
      return GyroscopeData(x: event.x, y: event.y, z: event.z);
    });
  }
}

/* import 'package:sensors_plus/sensors_plus.dart';
import '../models/gyroscope_model.dart';

class GyroscopeController {
  Stream<GyroscopeData> getGyroscopeData() {
    // Usar eventos del acelerómetro
    return accelerometerEvents.map((AccelerometerEvent event) {
      return GyroscopeData(x: event.x, y: event.y, z: event.z);
    });
  }
} */
