import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class AppDatabase {
  Box get appBox;
  Future<void> init();
}

class AppDatabaseImpl implements AppDatabase {
  final String hivePathSuffix;
  AppDatabaseImpl({required this.hivePathSuffix});
  late Box _appBox;
  @override
  Box get appBox => _appBox;
  @override
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init('${directory.path}/$hivePathSuffix/hive');
    _appBox = await Hive.openBox('notemaker_$hivePathSuffix');
  }
}
