import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HighlightsView extends StatelessWidget {
  const HighlightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                child: Lottie.network('https://assets2.lottiefiles.com/packages/lf20_p8bfn5to.json'),
              ),
              const SizedBox(height: 8),
              Text('Highlight $index'),
            ],
          ),
        );
      },
    );
  }
}
