// ignore_for_file: file_names

import 'package:geap_fit/utils/utils.dart';

import './path_name.dart';

class StaticNamesPath {
  static Path passwordGrant = Path(":signInWithPassword");
  static Path signInCI = Path("/sign_in_auth");
  static Path refresh = Path("/refresh");
  static Path authorize = Path("/oauth/authorize");
  static Path closeSession = Path("/close_session");
  static Path resendCode = Path("/resend_code");
  static Path credentials = Path("/oauth/info_from_credentials");
  static Path profile = Path("/my_profile");
  static Path getClients = Path("/users");
  static Path roles = Path("/roles");
  static Path selfSignUp = Path("/self_sign_up");
  static Path recover = Path("/recovery_questions");
  static Path sendRecover = Path("/recovery");
  static Path resend = Path("/self_sign_up_resend_code");
  static Path recoverExpired = Path("/password_expired");
  static Path securityQuestions = Path("/register_security_questions");
  static Path rate = Path("${MyUtils.type}/currency_exchange_rate/report");
  static Path createCategory = Path(
    "${MyUtils.type}/inventory_category/create_category",
  );
  static Path withdraw = Path(
    "${MyUtils.type}/inventory_pay_payment/withdrawal",
  );
}
