import 'package:flutter/material.dart';
import 'package:kite_fu/entity/fu.dart';

import 'util.dart';

class FuRecordListPage extends StatelessWidget {
  final List<MyCard> recordList;
  final String? title;
  final String emptyCardText;
  const FuRecordListPage(
    this.recordList, {
    Key? key,
    this.title,
    this.emptyCardText = '您尚未获得这张福卡',
  }) : super(key: key);

  Widget buildList() {
    return ListView.separated(
      itemBuilder: (context, i) {
        String enName = recordList[i].card.name;
        String name = cardTypeToString(recordList[i].card);
        return ListTile(
          minVerticalPadding: 20,
          leading: Image.asset('assets/fu/$name.png'),
          title: Text(name),
          subtitle: Text('获得时间: ${recordList[i].ts.toString().split('.')[0]}'),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    contentPadding: const EdgeInsets.all(0),
                    children: [Image.asset('assets/fu_card/$enName.jpg')],
                  );
                });
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: recordList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? '我的福卡')),
      body: recordList.isNotEmpty
          ? buildList()
          : Center(
              child: Text(emptyCardText),
            ),
    );
  }
}
