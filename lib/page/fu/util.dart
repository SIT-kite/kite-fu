import 'package:flutter/material.dart';
import 'package:kite_fu/entity/fu.dart';

String cardTypeToString(FuCard type) {
  return {
    FuCard.noCard: '暂无福卡',
    FuCard.sit: '上应福',
    FuCard.innovation: '创新福',
    FuCard.erudition: '博学福',
    FuCard.wealth: '富贵福',
    FuCard.health: '康宁福',
    FuCard.kite: '风筝福',
  }[type]!;
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
              Text("您确定要退出当前账号吗？"),
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
