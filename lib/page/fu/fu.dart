import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/global/service_pool.dart';
import 'package:kite_fu/global/storage_pool.dart';
import 'package:kite_fu/page/fu/fu_record_list.dart';
import 'package:kite_fu/page/fu/scan.dart';
import 'package:kite_fu/util/logger.dart';
import 'package:kite_fu/util/url_launcher.dart';

import 'util.dart';

class Fu {
  FuCard type;
  String name;
  int num;

  Fu(this.type, this.name, this.num);

  Widget buildFuWidget({GestureTapCallback? onTap}) {
    final card = InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Icon(Icons.book, size: 40),
          Image.asset('assets/fu/$name.png', width: 40, height: 40),
          // SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xFF, 252, 214, 177),
            ),
          ),
          Text(
            '已有$num张',
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(0xFF, 252, 214, 177),
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: card,
    );
  }

  /// 统计卡牌列表
  static List<Fu> fromCardList(List<MyCard> cards) {
    LinkedHashMap<FuCard, int> retMap = LinkedHashMap();
    retMap[FuCard.sit] = 0;
    retMap[FuCard.innovation] = 0;
    retMap[FuCard.erudition] = 0;
    retMap[FuCard.wealth] = 0;
    retMap[FuCard.health] = 0;
    for (final card in cards) {
      retMap[card.card] = retMap[card.card]! + 1;
    }
    return retMap.entries.map((entry) {
      return Fu(entry.key, cardTypeToString(entry.key), entry.value);
    }).toList();
  }
}

class FuPage extends StatefulWidget {
  const FuPage({Key? key}) : super(key: key);

  @override
  State<FuPage> createState() => _FuPageState();
}

class _FuPageState extends State<FuPage> {
  final currentUser = StoragePool.account.account;
  List<MyCard> myCards = [];

  @override
  void initState() {
    super.initState();
    Log.debug("FuPageState: initState");
  }

  Future<void> gotoScanPage() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const ScanPage();
    }));
    setState(() {});
  }

  Widget buildScanButton() {
    Widget view = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(220),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          SizedBox(child: Image.asset('assets/badge.png'), width: 200, height: 200),
          const SizedBox(height: 10),
          const Text(
            '扫校徽，领福卡',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xFF, 252, 214, 177),
            ),
          ),
        ],
      ),
    );
    return InkWell(onTap: gotoScanPage, child: view);
  }

  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(220),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '当前已登录用户: ${currentUser!.account}',
                      style: const TextStyle(color: Color.fromARGB(0xFF, 252, 214, 177)),
                    ),
                    TextButton(
                      onPressed: () {
                        logout(context);
                      },
                      child: const Text('退出登录', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                Text(
                  '您是第 ${currentUser!.uid} 个注册小风筝的用户',
                  style: const TextStyle(color: Color.fromARGB(0xFF, 252, 214, 177)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          buildScanButton(),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              await ServicePool.fu.share();
              launchInBrowser('https://mp.weixin.qq.com/s/jQLFmdG35WEGaDhkYJhEVg');
            },
            child: const Text(
              '打开活动公众号页面',
              style: TextStyle(color: Color.fromARGB(0xFF, 252, 214, 177)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFuRowItems() {
    Widget buildItem(List<MyCard> cardList, Fu fuItem) {
      return fuItem.buildFuWidget(onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return FuRecordListPage(
              cardList.where((e) => e.card == fuItem.type).toList(),
              title: '我的福卡(${fuItem.name})',
            );
          }),
        );
      });
    }

    return FutureBuilder<List<MyCard>>(
        future: ServicePool.fu.getList(),
        builder: (context, snapshot) {
          Log.info(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            Log.info(snapshot.data);
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data!;
            // 在 查看所有福卡 处复用福卡
            myCards = data;
            Log.info('显示福卡列表');
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: Row(
                children: (Fu.fromCardList(data)).map((e) {
                  return buildItem(data, e);
                }).toList(),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<void> logout(BuildContext context) async {
    final result = await showLogoutDialog(context);
    Log.info('对话框结果 $result');
    if (result) {
      StoragePool.jwt.jwtToken = null;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('福气等你来'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return FuRecordListPage(
                  myCards,
                  title: '我的所有福卡',
                  emptyCardText: '您还没有获得任何福卡',
                );
              }));
            },
            child: const Text('我的福卡', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              launchInBrowser('https://support.qq.com/products/377648');
            },
            child: const Text('反馈', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
        ),
        child: Column(children: [Expanded(child: buildBody()), buildFuRowItems()]),
      ),
    );
  }
}
