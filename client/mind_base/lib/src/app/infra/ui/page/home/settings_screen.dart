part of 'home.dart';

const _devPath =
    '/team/628895eb97858942e1ddb007/workspace/629393c8ebbbf5094df3e564/meta/""/view/-1';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const ListTile(title: Text("版本号"), trailing: Text(version)),
          if (kDebugMode) ...[
            ListTile(
              title: const Text("测试空间视图Url跳转"),
              onTap: () {
                // 学生测试, 学生表4, view1
                context.go(_devPath);
              },
              trailing: IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () async {
                  final target = await showTextInputDialog(
                      context: context, title: '路由跳转', origin: _devPath);
                  if (target != null) {
                    context.go(target);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text("测试异常抛出"),
              onTap: () {
                Future.value(BaseException("error")).thenDialog(context);
              },
            ),
            ListTile(
              title: const Text("测试Dialog异常抛出"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (c) => SizedBox(
                          width: 200,
                          height: 200,
                          child: Column(
                            children: [
                              TextButton(
                                child: const Text("抛出"),
                                onPressed: () {
                                  Future.value(BaseException("error"))
                                      .thenDialog(context);
                                },
                              ),
                            ],
                          ),
                        ));
              },
            ),
          ]
        ],
      ));
}
