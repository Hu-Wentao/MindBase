import 'package:get_arch_core/get_arch_core_interface.dart';

class Team {
  final String name;
  final String city;

  Team(this.name, this.city);

  @override
  String toString() {
    return 'Team{name: $name, city: $city}';
  }
}

class Workspace {
  final String name;
  final String path;

  Workspace(this.name, this.path);

  @override
  String toString() {
    return 'Workspace{name: $name, path: $path}';
  }
}

main() {
  final workspaces = {
    Team("aaa", '132'): [
      Workspace('name', 'path'),
      Workspace('name2', 'path2')
    ],
    Team("bbb", '133'): [],
  };

  final itemsData = workspaces.entries.expand((entry) {
    print("debug entry ${entry.key}");
    return entry.value.map(
      (e) => Tuple2(entry.key, e),
    );
  }).toList();
  print("debug itemsData ${itemsData}");
}
