import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kite_fu/global/mock_pool.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫描页'),
      ),
      body: ElevatedButton(
        child: Text('点击上传图片'),
        onPressed: () {
          MockPool.fu.upload(Uint8List(0));
        },
      ),
    );
  }
}
