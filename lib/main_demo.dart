import 'package:geap_fit/di/injection.dart';
import 'package:geap_fit/main_common.dart';
import 'package:geap_fit/utils/utils.dart';

Future<void> main() async {
  await MyUtils.loadDemo();
  mainCommon(Env.demo);
}
