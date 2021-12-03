part of 'hits_report_bloc.dart';

abstract class HitsReportEvent extends Equatable {
  const HitsReportEvent();

  @override
  List<Object> get props => [];
}

class FetchHitReportsEvent extends HitsReportEvent {
  final DateTime dateTime;
  final bool refresh;
  FetchHitReportsEvent({
    required this.dateTime,
    this.refresh = false,
  });
  @override
  // TODO: implement props
  List<Object> get props => [dateTime, refresh];
}
