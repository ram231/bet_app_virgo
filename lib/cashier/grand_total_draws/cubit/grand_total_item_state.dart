part of 'grand_total_item_cubit.dart';

class GrandTotalItemState extends Equatable {
  const GrandTotalItemState({
    this.items = const [],
    this.isLoading = false,
    this.error = '',
  });
  final List<BetResult> items;
  final bool isLoading;
  final String error;
  bool get hasError => error.isNotEmpty;
  @override
  List<Object> get props => [
        items,
        isLoading,
        error,
      ];

  GrandTotalItemState copyWith({
    List<BetResult>? items,
    bool isLoading = false,
    String error = '',
  }) {
    return GrandTotalItemState(
      items: items ?? this.items,
      isLoading: isLoading,
      error: error,
    );
  }
}
