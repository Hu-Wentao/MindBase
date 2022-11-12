part of 'home.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MainColumn.dense(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  "Google Financial",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Assets.images.discoverFake.image(
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerLeft,
                    height: 150,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
