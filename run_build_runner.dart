import 'dart:io';

const rootDirectory = '.';
const kiteWeatherEntityDirectory =
    '$rootDirectory/modules/kite_feature/modules/kite_feature_weather/modules/kite_weather_entity';
const kiteUserEntityDirectory = '$rootDirectory/modules/kite_user_entity';

Future<int> runPubGet({required String workingDirectory}) async {
  final result = await Process.start(
    'flutter',
    ['pub', 'get'],
    workingDirectory: workingDirectory,
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );
  return await result.exitCode;
}

Future<int> runBuildRunner({required String workingDirectory}) async {
  final result = await Process.start(
    'flutter',
    ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    workingDirectory: workingDirectory,
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );
  return await result.exitCode;
}

Future<void> generateCode({required String workingDirectory}) async {
  await runPubGet(workingDirectory: workingDirectory);
  await runBuildRunner(workingDirectory: workingDirectory);
}

/// 判断指定文件夹是否是dart package
bool isDartPackage(Directory directory) {
  final file = File('${directory.path}${Platform.pathSeparator}pubspec.yaml');
  return file.existsSync();
}

/// 获取项目中所有的dart package
Stream<Directory> getDartPackageDir({required String workingDirectory}) {
  return Directory(workingDirectory)
      .list(recursive: true)
      .where((event) => event is Directory && isDartPackage(event))
      .map((event) => event as Directory);
}

/// 获取小风筝的所有子模块
Stream<Directory> getAllSubModules() {
  return getDartPackageDir(workingDirectory: rootDirectory)
      .where((event) => event.path.startsWith('$rootDirectory${Platform.pathSeparator}modules'));
}

Future<void> runPubGetAll() async {
  final tasks = (await getAllSubModules().toSet()).map((e) => runPubGet(workingDirectory: e.path));
  await Future.wait(tasks);
}

Future<void> main() async {
  // await generateCode(workingDirectory: rootDirectory);
  // await generateCode(workingDirectory: kiteWeatherEntityDirectory);
  // await generateCode(workingDirectory: kiteUserEntityDirectory);
  await runPubGetAll();
}
