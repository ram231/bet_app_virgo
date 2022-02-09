part of 'grand_total_cubit.dart';

abstract class GrandTotalState extends Equatable {
  const GrandTotalState();

  @override
  List<Object?> get props => [];
}

class GrandTotalInitial extends GrandTotalState {}

class GrandTotalLoading extends GrandTotalState {}

class GrandTotalAdminLoaded extends GrandTotalState {
  GrandTotalAdminLoaded({
    this.items = const [],
    required this.fromDate,
    required this.toDate,
    this.error,
  });

  final List<AdminGrandTotal> items;
  final DateTime fromDate;
  final DateTime toDate;
  final Object? error;

  int get betGrandTotal => items.fold(
      0, (previousValue, element) => previousValue + element.betAmount);
  int get hitGrandTotal =>
      items.fold(0, (previousValue, element) => previousValue + element.hits);
  int get tapalGrandTotal =>
      items.fold(0, (prev, curr) => prev + (curr.betAmount - curr.hits));
  GrandTotalAdminLoaded copyWith({
    List<AdminGrandTotal>? items,
    DateTime? fromDate,
    DateTime? toDate,
    Object? error,
  }) {
    return GrandTotalAdminLoaded(
      items: items ?? this.items,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        items,
        error,
        fromDate,
        toDate,
      ];
}

class GrandTotalLoaded extends GrandTotalState {
  final int betAmount;
  final String readableBetAmount;
  final int hits;
  final String readableHits;
  final DateTime fromDate;
  final DateTime toDate;
  final Object? error;
  GrandTotalLoaded({
    required this.betAmount,
    required this.readableBetAmount,
    required this.hits,
    this.readableHits = '',
    required this.fromDate,
    required this.toDate,
    this.error,
  });
  bool get hasError => error != null;
  GrandTotalLoaded copyWith({
    int? betAmount,
    String? readableBetAmount,
    int? hits,
    DateTime? fromDate,
    DateTime? toDate,
    String? readableHits,
  }) {
    return GrandTotalLoaded(
      betAmount: betAmount ?? this.betAmount,
      readableBetAmount: readableBetAmount ?? this.readableBetAmount,
      hits: hits ?? this.hits,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      readableHits: readableHits ?? this.readableHits,
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
        readableHits,
      ];
}
