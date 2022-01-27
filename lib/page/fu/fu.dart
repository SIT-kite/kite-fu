import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/global/mock_pool.dart';
import 'package:kite_fu/global/storage_pool.dart';
import 'package:kite_fu/page/fu/award.dart';
import 'package:kite_fu/page/fu/fu_record_list.dart';
import 'package:kite_fu/page/fu/scan.dart';
import 'package:kite_fu/util/logger.dart';

import 'util.dart';

class Fu {
  FuType type;
  String name;
  int num;

  Fu(this.type, this.name, this.num);

  Widget buildFuWidget({GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.book, size: 40),
          // SizedBox(height: 10),
          Text(name),
          Text('已有$num张'),
        ],
      ),
    );
  }

  /// 统计卡牌列表
  static List<Fu> fromCardList(List<MyCard> cards) {
    LinkedHashMap<FuType, int> retMap = LinkedHashMap();
    retMap[FuType.loveCountry] = 0;
    retMap[FuType.wealthy] = 0;
    retMap[FuType.dedicateToWork] = 0;
    retMap[FuType.friendly] = 0;
    retMap[FuType.harmony] = 0;
    for (final card in cards) {
      retMap[card.type] = retMap[card.type]! + 1;
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
  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('当前已登录用户: ${currentUser!.account}'),
          Text('您是第 ${currentUser!.uid} 个注册小风筝的用户'),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return const ScanPage();
                }));
                setState(() {});
              },
              child: const Text('扫校徽领福卡'),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return const AwardPage();
                    }));
                  },
                  child: const Text('查看开奖结果'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return FuRecordListPage(
                        myCards,
                        title: '我的所有福卡',
                      );
                    }));
                  },
                  child: const Text('查看所有福卡'),
                ),
              ),
            ],
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
              cardList.where((e) => e.type == fuItem.type).toList(),
              title: '我的福卡(${fuItem.name})',
            );
          }),
        );
      });
    }

    return FutureBuilder<List<MyCard>>(
        future: MockPool.fu.getList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              myCards = data;
              return Row(
                children: Fu.fromCardList(data).map((e) {
                  return Expanded(child: buildItem(data, e));
                }).toList(),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<bool> showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认退出登录'),
          // 标题外间距
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          // 标题样式 TextStyle
          titleTextStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 25,
          ),
          // 内容外间距
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          // 内容样式 TextStyle
          contentTextStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              children: const [
                Padding(padding: EdgeInsets.all(15)),
                Text("将退出当前账户，是否退出？"),
              ],
            ),
          ),
          // 背景色
          backgroundColor: Colors.white,
          // 事件子控件间距
          actionsPadding: const EdgeInsets.all(15),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('退出登录'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('我点错了'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上应大扫校徽领奖品活动'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showLogoutDialog(context);
              Log.info('对话框结果 $result');
              if (result) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: buildBody(), flex: 10),
            Expanded(child: buildFuRowItems(), flex: 3),
          ],
        ),
      ),
    );
  }
}
