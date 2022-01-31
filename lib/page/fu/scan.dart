import 'dart:convert';
import 'dart:math';
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

    Widget showFuCard(BuildContext context, String name) {
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
    }

    String _getRandomPrompt() {
      const newFeatures = [
        '支持直接评教了',
        '关于您数据都存储在您的手机中',
        '首页下拉刷新可以更新所有信息',
        '可通过桌面图标直接进入每日上报页面',
        '还内置了几款小游戏哦~',
        '支持在网页上反馈了呢',
        // '开学前将与大家见面',
        '里长按课程即可选择并计算绩点',
        '在我手，告别上应大App',
        '可以方便地查阅书籍',
        '支持交易二手书啦！',
        '可以查看消费统计了！',
        '点击首页上的 logo 有更多功能'
      ];

      return '小风筝App' + newFeatures[Random().nextInt(newFeatures.length)];
    }

    Widget showKitePrompt(BuildContext context) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(0),
        children: [
          Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Image.asset('assets/fu_card/空白福.jpg'),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/icon.png'),
                    const Text('你知道吗'),
                    Text(_getRandomPrompt()),
                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text('我知道啦'),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Future<void> showFuCardResult() async {
      // 显示扫到福的结果
      String name = cardTypeToString(card);
      showScanResult(name);

      await showDialog(
        context: context,
        builder: card == FuCard.noCard ? showKitePrompt : (context) => showFuCard(context, name),
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
