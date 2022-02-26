part of 'hits_report_bloc.dart';

abstract class HitsReportState extends Equatable {
  const HitsReportState();

  @override
  List<Object> get props => [];
}

class HitsReportInitial extends HitsReportState {}

class HitsReportLoaded extends HitsReportState {
  final List<WinningHitsResult> draws;
  final DateTime drawDate;
  const HitsReportLoaded({
    this.draws = const [],
    required this.drawDate,
    this.error = "",
  });
  final String error;
  @override
  List<Object> get props => [
        draws,
        drawDate,
        error,
      ];
}

class HitsReportLoading extends HitsReportState {}
