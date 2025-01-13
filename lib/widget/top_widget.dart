import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopWidget extends ConsumerWidget {
  const TopWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/img_steam_logo_black.png',
              width: 250,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}