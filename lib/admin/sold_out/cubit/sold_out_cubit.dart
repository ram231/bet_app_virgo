import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/models.dart';

part 'sold_out_state.dart';

class SoldOutCubit extends Cubit<SoldOutState> {
  SoldOutCubit({required this.user, STLHttpClient? httpClient})
      : _http = httpClient ?? STLHttpClient(),
        super(SoldOutState());
  final STLHttpClient _http;
  final UserAccount user;
  Map<String, String> get _userParam => {
        'filter[show_all_or_not]': "${user.id},${user.type}",
      };
  void submit({
    required String number,
    String amount = '',
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _http.post('$adminEndpoint/${state.type}',
          queryParams: _userParam,
          body: {
            if (state.type == 'low-wins') ...{
              'winning_amount': amount,
              'low_win_number': number,
            } else
              'sold_out_number': number,
          },
          onSerialize: (json) => BetSoldOut.fromMap(json));
      final newItems = state.items..add(result);
      emit(state.copyWith(
        items: newItems,
      ));
    } catch (e) {
      emit(state.copyWith(error: throwableDioError(e)));
      addError(e);
    }
  }

  void delete({
    required int id,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _http.delete(
        '$adminEndpoint/${state.type}/$id',
        queryParams: _userParam,
      );
      final newItems = state.items.where((e) => e.id != id).toList();
      emit(state.copyWith(items: newItems));
    } catch (e) {
      emit(state.copyWith(error: throwableDioError(e)));
      addError(e);
    }
  }

  void fetch({String endPoint = 'sold-outs'}) async {
    assert(endPoint == 'sold-outs' || endPoint == 'low-wins');
    emit(state.copyWith(isLoading: true));
    try {
      final soldOuts = await _http.get('$adminEndpoint/$endPoint',
          onSerialize: (json) => (json['data'] as List)
              .map((e) => BetSoldOut.fromMap(e))
              .toList());

      emit(state.copyWith(
        items: soldOuts,
        type: endPoint,
      ));
    } catch (e) {
      addError(e);

      emit(state.copyWith(
        error: throwableDioError(e),
        type: endPoint,
      ));
    }
  }
}
