part of 'home.dart';
class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      children: const [
        ListTile(title: Text("版本号"), trailing: Text(version)),
      ],
    ),
  );
}