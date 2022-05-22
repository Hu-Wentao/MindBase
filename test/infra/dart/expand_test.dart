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

class TestWorkspace {
  final String name;
  final String path;

  TestWorkspace(this.name, this.path);

  @override
  String toString() {
    return 'Workspace{name: $name, path: $path}';
  }
}

main() {
  final workspaces = {
    TestTeam("aaa", '132'): [
      TestWorkspace('name', 'path'),
      TestWorkspace('name2', 'path2')
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
