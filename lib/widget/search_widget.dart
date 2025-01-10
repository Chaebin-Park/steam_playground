import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/riverpod/provider.dart';

class SearchWidget extends ConsumerWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerViewModel = ref.read(playerViewModelProvider.notifier);
    final TextEditingController textController = TextEditingController();

    print("4. search");
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          TextField(
            controller: textController,
            onSubmitted: (url) async {
              if (url.isNotEmpty) {
                print("submitted: $url");
                await playerViewModel.fetchPlayerSummaries(url);
              }
            },
            decoration: InputDecoration(
              labelText: 'Enter Steam Profile URL',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final url = textController.text;
                  if (url.isNotEmpty) {
                    print("onPressed: $url");
                    await playerViewModel.fetchPlayerSummaries(url);
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
