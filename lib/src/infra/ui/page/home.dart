import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Row(
          children: const [
            /// 展示 schema
            // Column(
            //   children: [
            //     //
            //   ],
            // ),
            /// 展示对应的表
          ],
        ),
      );
}
