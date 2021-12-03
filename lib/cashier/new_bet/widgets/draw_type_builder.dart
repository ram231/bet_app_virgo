import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/nil.dart';
import '../cubit/draw_type_cubit.dart';

class DrawTypeBuilder extends StatelessWidget {
  const DrawTypeBuilder({required this.builder, Key? key}) : super(key: key);
  final Widget Function(DrawTypesLoaded state) builder;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawTypeCubit, DrawTypeState>(
      builder: (context, state) {
        if (state is DrawTypesLoaded) {
          return builder(state);
        }
        return notNil;
      },
    );
  }
}
