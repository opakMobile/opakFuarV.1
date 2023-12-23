import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final Color color;
  final String message;

  const LoadingSpinner({Key? key, required this.color, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/ee1.gif', width: 80, height: 80),
          //CircularProgressIndicator(), deneme için silindi ama hoşta oldu
          SizedBox(height: 16),
          Text(message + '...'),
        ],
      ),
    );
  }
}
