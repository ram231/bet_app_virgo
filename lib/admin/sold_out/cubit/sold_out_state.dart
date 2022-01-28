part of 'sold_out_cubit.dart';

class SoldOutState extends Equatable {
  const SoldOutState({
    this.isLoading = false,
    this.items = const [],
    this.error = '',
  });
  final bool isLoading;
  final List<BetSoldOut> items;
  final String error;
  bool get hasError => error.isNotEmpty;
  @override
  List<Object> get props => [items, isLoading, error];

  SoldOutState copyWith({
    bool isLoading = false,
    List<BetSoldOut>? items,
    String? error,
  }) {
    return SoldOutState(
      isLoading: isLoading,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }
}
