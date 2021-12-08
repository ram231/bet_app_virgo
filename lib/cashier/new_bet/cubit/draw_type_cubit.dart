import 'package:bet_app_virgo/models/draw.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'draw_type_state.dart';

class DrawTypeCubit extends Cubit<DrawTypeState> {
  DrawTypeCubit({STLHttpClient? httpClient})
      : _httpClient = httpClient ?? STLHttpClient(),
        super(DrawTypeInitial());
  final STLHttpClient _httpClient;

  void fetchDrawTypes() async {
    try {
      emit(DrawTypeLoading());
      final result =
          await _httpClient.get('$adminEndpoint/draws', onSerialize: (json) {
        return json['data'];
      });
      debugPrint("$result");
      final list =
          (result as List).map((json) => DrawBet.fromMap(json)).toList();
      emit(DrawTypesLoaded(
          drawTypes: list,
          selectedDrawType: list
              .firstWhere((element) => element.winningCombination != null)));
    } catch (e) {
      debugPrint("$e");
    }
  }

  void changeDrawType(DrawBet drawType) {
    final _state = state;
    if (_state is DrawTypesLoaded) {
      emit(_state.copyWith(selectedDrawType: drawType));
    }
  }
}
