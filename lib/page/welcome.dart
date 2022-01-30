import 'package:flutter/material.dart';

import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image.
          SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: const Image(image: AssetImage("assets/welcome.jpg"), fit: BoxFit.cover)),
          // Transparent layer.
          // Container(color: Colors.black.withOpacity(0.35)),
          // Front weights. Texts and buttons are on the left bottom of the screen.
          Container(
            width: screenSize.width,
            height: screenSize.height,
            alignment: Alignment.bottomCenter,
            // 150 px from the bottom edge and 20 px from the left edge.
            padding: const EdgeInsets.only(bottom: 80),
            child: ElevatedButton(
                autofocus: true,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: const BorderSide(width: 1, color: Colors.yellow),
                ),
                child: const Text('过福年',
                    style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 40)),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                }),
          ),
        ],
      ),
      // Text button
    );
  }
}
