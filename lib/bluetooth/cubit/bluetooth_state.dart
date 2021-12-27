part of 'bluetooth_cubit.dart';

abstract class BetBluetoothState extends Equatable {
  const BetBluetoothState();

  @override
  List<Object> get props => [];
}

class BluetoothInitial extends BetBluetoothState {}

class BluetoothEmpty extends BetBluetoothState {}

class BluetoothLoaded extends BetBluetoothState {
  final BetBluetoothDevice device;
  const BluetoothLoaded({
    required this.device,
  });

  @override
  List<Object> get props => [device];

  BluetoothLoaded copyWith({
    BetBluetoothDevice? device,
  }) {
    return BluetoothLoaded(
      device: device ?? this.device,
    );
  }
}
