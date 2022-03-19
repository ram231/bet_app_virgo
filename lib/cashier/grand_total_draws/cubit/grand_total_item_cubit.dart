import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'grand_total_item_state.dart';

class GrandTotalItemCubit extends Cubit<GrandTotalItemState> {
  GrandTotalItemCubit({
    STLHttpClient? httpClient,
    required this.user,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(GrandTotalItemState());
  final STLHttpClient _httpClient;
  final UserAccount user;

  Map<String, String> get cashierIdParam => {
        'filter[show_all_or_not]': "${user.id},${user.type}",
      };

  void fetchByDrawId(int id) async {
    emit(state.copyWith(
      isLoading: true,
    ));

    try {
      final result = await _httpClient.get(
        '$adminEndpoint/bets',
        queryParams: {
          'filter[draw_id]': id,
          ...cashierIdParam,
          'filter[is_winner]': 1,
        },
        onSerialize: (json) =>
            (json['data'] as List).map((e) => BetResult.fromMap(e)).toList(),
      );
      emit(state.copyWith(items: result));
    } catch (e) {
      emit(state.copyWith(error: throwableDioError(e)));
    }
  }
}
