part of 'draw_type_cubit.dart';

abstract class DrawTypeState extends Equatable {
  const DrawTypeState();

  @override
  List<Object?> get props => [];
}

class DrawTypeInitial extends DrawTypeState {}

class DrawTypeLoading extends DrawTypeState {}

class DrawTypesLoaded extends DrawTypeState {
  final List<DrawBet> drawTypes;
  final DrawBet? selectedDrawType;
  const DrawTypesLoaded({this.drawTypes = const [], this.selectedDrawType});

  @override
  List<Object?> get props => [drawTypes, selectedDrawType];

  DrawTypesLoaded copyWith({
    List<DrawBet>? drawTypes,
    DrawBet? selectedDrawType,
  }) {
    return DrawTypesLoaded(
      drawTypes: drawTypes ?? this.drawTypes,
      selectedDrawType: selectedDrawType ?? this.selectedDrawType,
    );
  }
}
