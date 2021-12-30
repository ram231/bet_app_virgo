import 'package:bet_app_virgo/models/bluetooth_device.dart';
import 'package:bloc/bloc.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';

part 'blue_thermal_state.dart';

class BlueThermalCubit extends Cubit<BlueThermalState> {
  BlueThermalCubit() : super(BlueThermalInitial());

  @override
  Future<void> close() {
    disconnect();
    return super.close();
  }

  void scan() async {
    try {
      emit(BlueThermalLoading());

      final isConnected =
          (await BlueThermalPrinter.instance.isConnected) ?? false;
      if (isConnected) {
        await BlueThermalPrinter.instance.disconnect();
      }
      final result = await BlueThermalPrinter.instance.getBondedDevices();
      final devices =
          result.map((e) => BetBluetoothDevice.fromMap(e.toMap())).toList();
      final bool isOn = await BlueThermalPrinter.instance.isOn ?? false;
      emit(BlueThermalLoaded(devices: devices, isConnected: isOn));
    } catch (e) {
      emit(BlueThermalLoaded(devices: [], error: "$e"));
    }
  }

  void connect(BetBluetoothDevice device) async {
    try {
      final isConnected =
          (await BlueThermalPrinter.instance.isConnected) ?? false;
      if (isConnected) {
        await BlueThermalPrinter.instance.disconnect();
      }
      await BlueThermalPrinter.instance
          .connect(BluetoothDevice.fromMap(device.toMap()));
      final _state = state;
      if (_state is BlueThermalLoaded) {
        final devices = [..._state.devices];
        final index = devices.indexOf(device);
        devices[index] = device.copyWith(connected: true);
        emit(_state.copyWith(devices: devices));
      }
    } catch (e) {
      final _state = state;
      if (_state is BlueThermalLoaded) {
        emit(_state.copyWith(error: "$e"));
        return;
      }
      emit(BlueThermalLoaded(devices: [], error: "$e"));
    }
  }

  void disconnect() async {
    await BlueThermalPrinter.instance.disconnect();
    final _state = state;
    if (_state is BlueThermalLoaded) {
      final devices =
          _state.devices.map((e) => e.copyWith(connected: false)).toList();
      emit(_state.copyWith(devices: devices));
    }
  }
}
