// ignore_for_file: file_names

import 'package:sports_management/utils/utils.dart';

import './path_name.dart';

class StaticNamesPath {
  static Path passwordGrant = Path(":signInWithPassword");
  static Path signInCI = Path("/sign_in_auth");
  static Path refresh = Path("/refresh");
  static Path authorize = Path("/oauth/authorize");
  static Path closeSession = Path("/close_session");
  static Path resendCode = Path("/resend_code");
  static Path credentials = Path("/oauth/info_from_credentials");
  static Path profile = Path("${MyUtils.type}/my_profile");
  static Path init = Path("${MyUtils.type}/init");
  static Path roles = Path("${MyUtils.type}/roles");
  static Path account = Path("${MyUtils.type}/service_pay/consultation");
  static Path inventory = Path("${MyUtils.type}/service_pay_inventory/get2");
  static Path banks = Path("${MyUtils.type}/service_pay_payment/collect_channel");
  static Path balancePayment = Path("/service_pay_payment/balance_payment");
  static Path selfSignUp = Path("/self_sign_up");
  static Path recover = Path("/recovery_questions");
  static Path sendRecover = Path("/recovery");
  static Path resend = Path("/self_sign_up_resend_code");
  static Path recoverExpired = Path("/password_expired"); 
  static Path securityQuestions = Path("/register_security_questions");
  static Path rate = Path("${MyUtils.type}/currency_exchange_rate/report");
  static Path details = Path("${MyUtils.type}/service_pay_inventory_movement/report");
  static Path payment = Path("${MyUtils.type}/service_pay/payment");
  static Path createCategory =
    Path("${MyUtils.type}/inventory_category/create_category");
  static Path withdraw =
    Path("${MyUtils.type}/inventory_pay_payment/withdrawal");
}
