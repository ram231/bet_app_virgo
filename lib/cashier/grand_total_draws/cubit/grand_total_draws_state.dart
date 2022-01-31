part of 'grand_total_draws_cubit.dart';

class GrandTotalDrawsState extends Equatable {
  const GrandTotalDrawsState({
    this.isLoading = false,
    this.error = '',
    this.draws = const [],
  });
  final List<WinningHitsResult> draws;
  final bool isLoading;
  final String error;
  bool get hasErrors => error.isNotEmpty;
  @override
  List<Object> get props => [
        draws,
        error,
        isLoading,
      ];

  GrandTotalDrawsState copyWith({
    List<WinningHitsResult>? draws,
    bool isLoading = false,
    String? error,
  }) {
    return GrandTotalDrawsState(
      draws: draws ?? this.draws,
      isLoading: isLoading,
      error: error ?? this.error,
    );
  }
}
