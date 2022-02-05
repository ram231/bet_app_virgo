import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

EventTransformer<T> debounceEvent<T>(Duration duration,
    {Stream<T> Function(Stream<T> events, Stream<T> Function(T) transitionFn)?
        onTransform}) {
  return (events, transitionFn) =>
      (onTransform?.call(events, transitionFn) ?? events)
          .debounceTime(duration)
          .switchMap(transitionFn);
}
