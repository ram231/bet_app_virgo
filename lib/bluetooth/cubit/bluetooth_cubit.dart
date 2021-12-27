import 'package:bet_app_virgo/models/bluetooth_device.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bluetooth_state.dart';

class BluetoothCubit extends Cubit<BetBluetoothState> {
  BluetoothCubit() : super(BluetoothInitial());
  void connectDevice(BetBluetoothDevice device) {
    emit(BluetoothLoaded(device: device));
  }

  void disconnectDevice() {
    emit(BluetoothEmpty());
  }
}
