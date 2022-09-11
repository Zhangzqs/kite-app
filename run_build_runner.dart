import 'dart:io';

const rootDirectory = '.';
const kiteWeatherEntityDirectory =
    '$rootDirectory/modules/kite_feature/modules/kite_feature_weather/modules/kite_weather_entity';
const kiteUserEntityDirectory = '$rootDirectory/modules/kite_user_entity';

Future<int> get({required String workingDirectory}) async {
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
  await get(workingDirectory: workingDirectory);
  await runBuildRunner(workingDirectory: workingDirectory);
}

Future<void> main() async {
  await generateCode(workingDirectory: rootDirectory);
  await generateCode(workingDirectory: kiteWeatherEntityDirectory);
  await generateCode(workingDirectory: kiteUserEntityDirectory);
}
