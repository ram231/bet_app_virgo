import 'package:bet_app_virgo/models/draw.dart';
import 'package:bloc/bloc.dart';

class DrawData extends Cubit<DrawBet> {
  DrawData({required DrawBet data, String}) : super(data);
  void update(DrawBet draw) {
    emit(draw);
  }
}
