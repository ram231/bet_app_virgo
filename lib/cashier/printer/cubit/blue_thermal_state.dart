part of 'blue_thermal_cubit.dart';

class BlueThermalLoaded extends Equatable {
  final List<BetBluetoothDevice> devices;
  final String error;
  final bool isConnected;
  final bool isLoading;
  const BlueThermalLoaded({
    this.devices = const [],
    this.error = '',
    this.isConnected = false,
    this.isLoading = false,
  });
  bool get hasError => error.isNotEmpty;
  bool get isEmpty => devices.isEmpty;
  @override
  List<Object?> get props => [
        devices,
        error,
        isConnected,
        isLoading,
      ];

  BlueThermalLoaded copyWith({
    List<BetBluetoothDevice>? devices,
    String error = '',
    bool? isConnected,
    bool isLoading = false,
  }) {
    return BlueThermalLoaded(
      devices: devices ?? this.devices,
      error: error,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading,
    );
  }
}
