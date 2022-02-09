import 'dart:async';

import 'package:bet_app_virgo/models/bluetooth_device.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';

part 'blue_thermal_state.dart';

class BlueThermalCubit extends Cubit<BlueThermalLoaded> {
  BlueThermalCubit({BlueThermalPrinter? printer})
      : _instance = printer ?? BlueThermalPrinter.instance,
        super(BlueThermalLoaded());
  final BlueThermalPrinter _instance;
  StreamSubscription<int?>? _streamSubscription;
  @override
  Future<void> close() {
    disconnect();

    return super.close();
  }

  void _onListen() {
    _streamSubscription?.cancel();
    _streamSubscription = _instance.onStateChanged().listen((event) {
      emit(state.copyWith(isConnected: event == BlueThermalPrinter.CONNECTED));
    });
  }

  void scan() async {
    try {
      emit(state.copyWith(isLoading: true));

      final isConnected = (await _instance.isConnected) ?? false;
      if (isConnected) {
        await _instance.disconnect();
      }
      _onListen();
      final result = await _instance.getBondedDevices();
      final devices =
          result.map((e) => BetBluetoothDevice.fromMap(e.toMap())).toList();
      final bool isOn = await _instance.isOn ?? false;
      emit(state.copyWith(devices: devices, isConnected: isOn));
    } catch (e) {
      emit(BlueThermalLoaded(devices: [], error: throwableDioError(e)));
    }
  }

  void connect(BetBluetoothDevice device) async {
    try {
      final isConnected = (await _instance.isConnected) ?? false;
      if (isConnected) {
        await _instance.disconnect();
      }
      await _instance.connect(BluetoothDevice.fromMap(device.toMap()));
      final _state = state;
      final devices = [..._state.devices];
      final index = devices.indexOf(device);
      devices[index] = device.copyWith(connected: true);
      emit(_state.copyWith(devices: devices));
    } catch (e) {
      final _state = state;
      emit(_state.copyWith(error: throwableDioError(e)));
    }
  }

  void disconnect() async {
    _streamSubscription?.cancel();
    await _instance.disconnect();
    final _state = state;
    final devices =
        _state.devices.map((e) => e.copyWith(connected: false)).toList();
    emit(_state.copyWith(devices: devices, isConnected: false));
  }
}
