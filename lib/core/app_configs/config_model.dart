import 'package:hive/hive.dart';
part 'config_model.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 4)
class AppConfig extends HiveObject {
  AppConfig({
    required this.examplesDone,
    required this.colorScheme,
  });

  @HiveField(0)
  bool examplesDone;
  @HiveField(1)
  String colorScheme;

  @override
  String toString() {
    return 'examplesDone $examplesDone, colorScheme $colorScheme';
  }
}
