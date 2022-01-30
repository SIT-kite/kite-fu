import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/global/service_pool.dart';
import 'package:kite_fu/page/fu/util.dart';
import 'package:kite_fu/util/logger.dart';
import 'package:kite_fu/util/url_launcher.dart';
import 'package:oktoast/oktoast.dart';
import 'package:webviewx/webviewx.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Size get screenSize => MediaQuery.of(context).size;
  WebViewXController? webviewController;

  bool isCameraErrorState = false;

  Future<bool> isCameraInit() async {
    return await webviewController!.callJsMethod('isInitSuccessful', []);
  }

  Future<bool> isCameraError() async {
    return await webviewController!.callJsMethod('isInitError', []);
  }

  Future<Uint8List?> takePhoto() async {
    if (webviewController == null) {
      return null;
    } else {
      String imageBase64 = await webviewController!.callJsMethod('takePhoto', []);
      return base64Decode(imageBase64.split(',')[1]);
    }
  }

  /// 当获取到扫描结果时
  Future<void> onGotScanResult(UploadResult result, FuCard card) async {
    showScanResult(String showText) {
      Log.info(showText);
      return showToast(
        showText,
        position: ToastPosition.bottom,
        context: context,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 13.0,
      );
    }

    Future<void> showFuCardResult() async {
      // 显示扫到福的结果
      String name = cardTypeToString(card);
      showScanResult(name);
      if (card == FuCard.noCard) {
        // TODO 没扫到应当显示一些其他东西
        return;
      }
      await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(0),
            children: [
              Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  Image.asset('assets/fu_card/$name.jpg'),
                  Positioned(
                    bottom: 30,
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () async {
                          showScanResult('恭喜您，您收获了一张$name');
                          Navigator.pop(context);
                        },
                        child: const Text('立即收下'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    switch (result) {
      case UploadResult.noBadge:
        showScanResult('快去找一个校徽吧 😂');
        break;
      case UploadResult.maxLimit:
        showScanResult('已达当日最大次数限制 😭');
        break;
      case UploadResult.successful:
        await showFuCardResult();
        break;
      case UploadResult.outdated:
        showScanResult('活动已过期 😱');
        Navigator.pop(context);
        break;
    }
  }

  Future<void> loop() async {
    Log.info('进入拍照循环');
    while (true) {
      if (webviewController == null) {
        break;
      }
      if (await isCameraError()) {
        Log.info('相机错误');
        setState(() {
          isCameraErrorState = true;
        });
      }
      await Future.delayed(const Duration(seconds: 3));
      if (await isCameraInit()) {
        Log.info('相机初始化成功');
        final imageBuffer = await takePhoto();
        if (imageBuffer != null && imageBuffer.isNotEmpty) {
          try {
            UploadResultModel result = await ServicePool.fu.upload(imageBuffer);
            await onGotScanResult(result.result, result.card);
          } catch (_) {}
        }
      }
    }
  }

  Widget buildCameraView(String htmlSource) {
    return WebViewX(
      initialContent: htmlSource,
      initialSourceType: SourceType.html,
      height: screenSize.height,
      width: screenSize.width,
      onWebViewCreated: (controller) => webviewController = controller,
      onPageFinished: (String src) async {
        Log.info('WebView页面加载完毕');
        // 开始进入拍照循环
        loop();
      },
    );
  }

  @override
  void dispose() {
    Log.info('相机已销毁');
    webviewController?.dispose();
    webviewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildErrorPage() {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            '当前浏览器环境不支持开启摄像头',
            '请尝试更换浏览器重试',
          ].map((e) {
            return Text(e, style: const TextStyle(fontSize: 25));
          }).toList(),
        ),
      );
    }

    Widget buildNormalPage() {
      return FutureBuilder<String>(
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
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('扫一扫 迎福卡'),
          actions: [
            // IconButton(
            //     onPressed: () async {
            //       final image = await MockPool.fu.upload(Uint8List(0));
            //       onGotScanResult(image.result, image.card);
            //     },
            //     icon: Icon(Icons.add)),
            TextButton(
              onPressed: () => launchInBrowser('https://support.qq.com/products/377648'),
              child: const Text('反馈', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: isCameraErrorState ? buildErrorPage() : buildNormalPage());
  }
}
