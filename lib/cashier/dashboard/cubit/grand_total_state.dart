part of 'grand_total_cubit.dart';

abstract class GrandTotalState extends Equatable {
  const GrandTotalState();

  @override
  List<Object> get props => [];
}

class GrandTotalInitial extends GrandTotalState {}

class GrandTotalLoading extends GrandTotalState {}

class GrandTotalLoaded extends GrandTotalState {
  final int betAmount;
  final String readableBetAmount;
  final int hits;
  GrandTotalLoaded({
    required this.betAmount,
    required this.readableBetAmount,
    required this.hits,
  });

  GrandTotalLoaded copyWith({
    int? betAmount,
    String? readableBetAmount,
    int? hits,
  }) {
    return GrandTotalLoaded(
      betAmount: betAmount ?? this.betAmount,
      readableBetAmount: readableBetAmount ?? this.readableBetAmount,
      hits: hits ?? this.hits,
    );
  }

  @override
  List<Object> get props => [
        betAmount,
        hits,
        readableBetAmount,
      ];
}
