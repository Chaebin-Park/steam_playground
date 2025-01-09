import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final Function(String url) onPressed;

  SearchWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter Steam Profile URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onPressed(_controller.text);
              _controller.clear();
            },
            child: const Text('Search'),
          ),
        ]),
      ),
    );
  }
}
