import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomWidget extends ConsumerWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Text("copyright")
    );
  }
}