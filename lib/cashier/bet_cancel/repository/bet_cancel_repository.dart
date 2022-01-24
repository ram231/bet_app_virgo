import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bet_app_virgo/utils/http_client.dart';

abstract class BetCancelInterface {
  Future<List<BetResult>> fetch({
    String search = '',
    bool refresh = false,
  });
}

class BetCancelRepository implements BetCancelInterface {
  final _http = STLHttpClient();
  final _cache = [];
  @override
  Future<List<BetResult>> fetch({
    final String search = '',
    bool refresh = false,
  }) async {
    if (refresh) {
      _cache.clear();
    }
    final result = await _http.get(
      '$adminEndpoint/bets',
      onSerialize: (json) => json['data'] as List,
    );
    final lists = result.map((e) => BetResult.fromMap(e)).toList();
    _cache.addAll(lists);
    return lists;
  }
}
