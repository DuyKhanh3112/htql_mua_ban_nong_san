import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SpinKitThreeBounce(
      color: Color.fromARGB(255, 216, 120, 64),
      size: 50.0,
    ));
  }
}
