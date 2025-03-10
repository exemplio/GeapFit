import 'package:sports_management/di/injection.dart';
import 'package:sports_management/main_common.dart';
import 'package:sports_management/utils/utils.dart';

Future<void> main() async {
  await MyUtils.loadDemo();
  mainCommon(Env.demo);
}
