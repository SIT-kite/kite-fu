import 'package:flutter/material.dart';
import 'package:kite_fu/entity/kite/fu.dart';

import 'util.dart';

class FuRecordListPage extends StatelessWidget {
  final List<MyCard> recordList;
  final String? title;
  const FuRecordListPage(this.recordList, {Key? key, this.title}) : super(key: key);

  Widget buildList() {
    return ListView.separated(
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(cardTypeToString(recordList[i].type)),
            subtitle: Text(recordList[i].ts.toString().split('.')[0]),
          );
        },
        separatorBuilder: (context, index) => const ColoredBox(
              color: Colors.grey,
              child: SizedBox(
                height: 1,
              ),
            ),
        itemCount: recordList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '我的福卡'),
      ),
      body: recordList.isNotEmpty
          ? buildList()
          : const Center(
              child: Text('您还没有获得此卡片'),
            ),
    );
  }
}
