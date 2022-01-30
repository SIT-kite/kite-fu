import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite_fu/global/service_pool.dart';
import 'package:kite_fu/util/logger.dart';
import 'package:webviewx/webviewx.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Size get screenSize => MediaQuery.of(context).size;
  WebViewXController? webviewController;

  Future<Uint8List?> takePhoto() async {
    if (webviewController == null) {
      return null;
    } else {
      String imageBase64 = await webviewController!.callJsMethod('takePhoto', []);
      return base64Decode(imageBase64.split(',')[1]);
    }
  }

  void onCameraInitialized() {
    Log.info('摄像头正常启动');
    (() async {
      while (true) {
        await Future.delayed(const Duration(seconds: 3));
        final imageBuffer = await takePhoto();
        if (imageBuffer != null && imageBuffer.isNotEmpty) {
          ServicePool.fu.upload(imageBuffer);
        }
      }
    })();
  }

  void onCameraError(msg) {
    Log.info('摄像头发生异常');
  }

  Widget buildCameraView(String htmlSource) {
    return WebViewX(
      initialContent: htmlSource,
      initialSourceType: SourceType.html,
      height: screenSize.height,
      width: screenSize.width,
      onWebViewCreated: (controller) => webviewController = controller,
      dartCallBacks: {
        DartCallback(
            name: 'cameraViewInitialized',
            callBack: (msg) {
              Log.info('摄像头已启动');
              onCameraInitialized();
            }),
        DartCallback(
            name: 'cameraViewInitializedError',
            callBack: (msg) {
              Log.info('摄像头启动失败');
              onCameraError(msg);
            }),
      },
    );
  }

  @override
  void dispose() {
    webviewController?.dispose();
    webviewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫一扫 迎福卡'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await takePhoto();
              await ServicePool.fu.upload(image!);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/scan/index.html'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              String data = snapshot.data!;
              return buildCameraView(data);
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
