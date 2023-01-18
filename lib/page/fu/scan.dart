import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/global/service_pool.dart';
import 'package:kite_fu/page/fu/util.dart';
import 'package:kite_fu/util/logger.dart';
import 'package:kite_fu/util/url_launcher.dart';
import 'package:webviewx/webviewx.dart';

class ScanPage extends StatefulWidget {
  final String userMode;
  const ScanPage({
    Key? key,
    this.userMode = 'USER',
  }) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Size get screenSize => MediaQuery.of(context).size;
  WebViewXController? webviewController;

  bool isCameraErrorState = false;
  bool webViewHideState = false;
  Future<bool> isCameraInit() async {
    if (webviewController == null) {
      return false;
    }
    return await webviewController!.callJsMethod('isInitSuccessful', []);
  }

  Future<bool> isCameraError() async {
    if (webviewController == null) {
      return false;
    }
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

  /// 显示toast
  showScanResult(String showText) {
    Log.info(showText);
    EasyLoading.showToast(showText, toastPosition: EasyLoadingToastPosition.bottom);
  }

  /// 当获取到扫描结果时
  Future<void> onGotScanResult(UploadResult result, FuCard card) async {
    /// 显示福卡
    Widget showFuCard(BuildContext context, FuCard card) {
      String name = cardTypeToString(card);
      showScanResult('🎉🎉🎉恭喜收获了 $name 一张');
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(0),
        children: [
          Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Image.asset('assets/fu_card/${card.name}.jpg'),
              Positioned(
                bottom: 30,
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
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

    /// 获取随机语言，用于无福卡时弹出
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
      Widget buildText() {
        return Column(
          children: [
            const Text(
              '你知道吗',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xFF, 252, 214, 177),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 50, right: 50),
              child: Text(
                _getRandomPrompt(),
                style: const TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                  color: Color.fromARGB(0xFF, 252, 214, 177),
                ),
              ),
            )
          ],
        );
      }

      Widget buildContentView() {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon.png',
                height: 100,
              ),
              const SizedBox(height: 100),
              buildText(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text('我知道啦'),
              ),
            ],
          ),
        );
      }

      showScanResult('很抱歉，未抽中福卡😭');
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(0),
        children: [
          Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Image.asset('assets/fu_card/noCard.jpg'),
              buildContentView(),
            ],
          ),
        ],
      );
    }

    Future<void> showFuCardResult() async {
      // 显示扫到福的结果
      String name = cardTypeToString(card);
      // showScanResult(name);
      Log.info('收到了一张 ' + name);

      setState(() {
        webViewHideState = true;
      });

      await showDialog(
        context: context,
        builder: card == FuCard.noCard ? showKitePrompt : (context) => showFuCard(context, card),
      );
      setState(() {
        webViewHideState = false;
      });
    }

    switch (result) {
      case UploadResult.noBadge:
        showScanResult('快去找一个校徽吧 😂');
        break;
      case UploadResult.maxLimit:
        showScanResult('已达当日最大次数限制 😭\n公众号可再领取一次机会(限每天一次)');
        break;
      case UploadResult.successful:
        showFuCardResult();
        break;
      case UploadResult.tooLate:
        showScanResult('来晚了，活动已过期 😱');
        Navigator.pop(context);
        break;
      case UploadResult.tooEarly:
        showScanResult('来早了，活动还未开始哦~ 😊');
        Navigator.pop(context);
        break;
    }
  }

  Future<void> loopOnce() async {
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
          try {
            UploadResultModel result = await ServicePool.fu.upload(imageBuffer);
            await onGotScanResult(result.result, result.card);
          } catch (e) {
            showScanResult('网络异常:$e');
          }
        } catch (_) {}
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
        while (true) {
          if (webviewController == null) {
            break;
          }
          await loopOnce();
        }
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

  Widget? webview;

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

    Widget buildNormalPage(String mode) {
      webview ??= FutureBuilder<String>(
        future: rootBundle.loadString('assets/scan/index.html'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              String data = snapshot.data!;
              Log.info('成功构造相机：$mode');
              return buildCameraView(data.replaceAll('{{ CAMERA_MODE }}', mode));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      return webview!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('扫一扫 迎福卡'),
        actions: [
          TextButton(
            onPressed: () {
              if (widget.userMode == 'USER') {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return const ScanPage(userMode: 'ENVIRONMENT');
                }));
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return const ScanPage(userMode: 'USER');
                }));
              }
            },
            child: const Text('切换相机', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => launchInBrowser('https://support.qq.com/products/377648'),
            child: const Text('反馈', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: webViewHideState ? Container() : (isCameraErrorState ? buildErrorPage() : buildNormalPage(widget.userMode)),
    );
  }
}
