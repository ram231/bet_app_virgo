part of 'grand_total_cubit.dart';

abstract class GrandTotalState extends Equatable {
  const GrandTotalState();

  @override
  List<Object?> get props => [];
}

class GrandTotalInitial extends GrandTotalState {}

class GrandTotalLoading extends GrandTotalState {}

class GrandTotalLoaded extends GrandTotalState {
  final int betAmount;
  final String readableBetAmount;
  final int hits;
  final String? fromDate;
  final String? toDate;
  final Object? error;
  GrandTotalLoaded({
    required this.betAmount,
    required this.readableBetAmount,
    required this.hits,
    this.fromDate,
    this.toDate,
    this.error,
  });
  bool get hasError => error != null;
  GrandTotalLoaded copyWith({
    int? betAmount,
    String? readableBetAmount,
    int? hits,
    String? fromDate,
    String? toDate,
  }) {
    return GrandTotalLoaded(
      betAmount: betAmount ?? this.betAmount,
      readableBetAmount: readableBetAmount ?? this.readableBetAmount,
      hits: hits ?? this.hits,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  List<Object?> get props => [
        betAmount,
        hits,
        readableBetAmount,
        fromDate,
        toDate,
        error,
      ];
}
