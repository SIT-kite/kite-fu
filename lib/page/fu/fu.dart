import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/global/mock_pool.dart';
import 'package:kite_fu/page/fu/award.dart';
import 'package:kite_fu/page/fu/fu_record_list.dart';
import 'package:kite_fu/page/fu/scan.dart';

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
  List<MyCard> myCards = [];
  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上应大扫校徽领奖品活动'),
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
