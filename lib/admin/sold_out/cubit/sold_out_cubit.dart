import 'package:bet_app_virgo/models/sold_out.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sold_out_state.dart';

class SoldOutCubit extends Cubit<SoldOutState> {
  SoldOutCubit({STLHttpClient? httpClient})
      : _http = httpClient ?? STLHttpClient(),
        super(SoldOutState());
  final STLHttpClient _http;

  void submit({
    required String number,
    required String type,
    String amount = '',
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _http.post('$adminEndpoint/${type}',
          body: {
            'sold_out_number': int.parse(number),
            'winning_amount': amount,
            'low_win_number': int.parse(number),
          },
          onSerialize: (json) => BetSoldOut.fromMap(json));
      final newItems = state.items..add(result);
      emit(state.copyWith(
        items: newItems,
      ));
    } catch (e) {
      addError(e);
    }
  }

  void fetch() async {
    emit(state.copyWith(isLoading: true));
    try {
      final soldOuts = await _http.get('$adminEndpoint/sold-outs',
          onSerialize: (json) => (json['data'] as List)
              .map((e) => BetSoldOut.fromMap(e))
              .toList());
      final lowWins = await _http.get(
        '$adminEndpoint/low-wins',
        onSerialize: (json) =>
            (json['data'] as List).map((e) => BetSoldOut.fromMap(e)).toList(),
      );

      final newItems = [
        ...state.items,
        ...soldOuts,
        ...lowWins,
      ];
      emit(state.copyWith(items: newItems));
    } catch (e) {
      addError(e);

      emit(state.copyWith(error: "$e"));
    }
  }
}
