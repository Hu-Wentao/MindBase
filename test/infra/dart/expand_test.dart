import 'package:get_arch_core/get_arch_core_interface.dart';

class TestTeam {
  final String name;
  final String city;

  TestTeam(this.name, this.city);

  @override
  String toString() {
    return 'Team{name: $name, city: $city}';
  }
}

class TestSpaceModel {
  final String name;
  final String path;

  TestSpaceModel(this.name, this.path);

  @override
  String toString() {
    return 'SpaceModel{name: $name, path: $path}';
  }
}

main() {
  final workspaces = {
    TestTeam("aaa", '132'): [
      TestSpaceModel('name', 'path'),
      TestSpaceModel('name2', 'path2')
    ],
    TestTeam("bbb", '133'): [],
  };

  final itemsData = workspaces.entries.expand((entry) {
    print("debug entry ${entry.key}");
    return entry.value.map(
      (e) => Tuple2(entry.key, e),
    );
  }).toList();
  print("debug itemsData ${itemsData}");
}
