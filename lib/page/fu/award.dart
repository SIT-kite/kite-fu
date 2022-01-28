import 'package:flutter/material.dart';
import 'package:kite_fu/entity/fu.dart';
import 'package:kite_fu/global/service_pool.dart';

class AwardPage extends StatelessWidget {
  const AwardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('开奖结果'),
      ),
      body: FutureBuilder<PraiseResult>(
        future: ServicePool.fu.getResult(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              if (data.hasResult) {
                return Text('url: ${data.url}');
              } else {
                return Text('结果未出');
              }
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
