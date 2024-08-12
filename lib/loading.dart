import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Image(
          image: NetworkImage(
              'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723004576/app/logo_circle.png'),
          height: 100,
        ),
        SpinKitDualRing(
          color: Colors.green,
          size: 130,
        ),
      ],
    ));
  }
}
