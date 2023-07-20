import 'package:flutter/material.dart';
import 'package:ttt/loadingPage.dart';

main() {
  runApp(Application());
}


class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Loading(),
    );
  }
}
