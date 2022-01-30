import 'package:flutter/material.dart';
import 'package:kite_fu/global/service_pool.dart';

class AwardPage extends StatelessWidget {
  const AwardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('开奖结果'),
      ),
      body: FutureBuilder<String?>(
        future: ServicePool.fu.getResult(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            final data = snapshot.data;
            if (data != null) {
              return Text('url: $data');
            } else {
              return const Text('结果未出');
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
