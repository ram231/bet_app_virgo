part of 'blue_thermal_cubit.dart';

abstract class BlueThermalState extends Equatable {
  const BlueThermalState();

  @override
  List<Object?> get props => [];
}

class BlueThermalInitial extends BlueThermalState {}

class BlueThermalLoading extends BlueThermalState {}

class BlueThermalLoaded extends BlueThermalState {
  final List<BetBluetoothDevice> devices;
  final String? error;
  bool isConnected;
  BlueThermalLoaded({
    required this.devices,
    this.error,
    this.isConnected = false,
  });
  bool get hasError => error != null;
  bool get isEmpty => devices.isEmpty;
  @override
  List<Object?> get props => [devices, error, isConnected];

  BlueThermalLoaded copyWith({
    List<BetBluetoothDevice>? devices,
    String? error,
    bool? isConnected,
  }) {
    return BlueThermalLoaded(
      devices: devices ?? this.devices,
      error: error ?? this.error,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
