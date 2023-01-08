import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kite_fu/global/storage_pool.dart';
import 'package:kite_fu/page/route_table.dart';

const backgroundList = ["1.jpg", "2.png", "3.jpg", "4.jpg", "5.jpg"];

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final bg = backgroundList[Random().nextInt(backgroundList.length)];

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
              child: Image(image: AssetImage("assets/welcome/$bg"), fit: BoxFit.cover)),
          // Transparent layer.
          // Container(color: Colors.black.withOpacity(0.35)),
          // Front weights. Texts and buttons are on the left bottom of the screen.
          Container(
            width: screenSize.width,
            height: screenSize.height,
            alignment: Alignment.bottomCenter,
            // 150 px from the bottom edge and 20 px from the left edge.
            padding: const EdgeInsets.only(bottom: 80),
            child: GestureDetector(
                child: Image.asset('assets/welcome/button.png', height: 50),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    StoragePool.jwt.jwtToken == null ? RouteTable.loginPath : RouteTable.fuPath,
                  );
                }),
          ),
        ],
      ),
      // Text button
    );
  }
}
