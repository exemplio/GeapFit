import 'dart:ui';

import 'package:sports_management/styles/color_provider/color_provider.dart';

class ColorProviderImpl extends ColorProvider {
  final Color _primary;
  final Color _primaryLight;

  ColorProviderImpl(this._primary, this._primaryLight);

  @override
  Color primary() {
    return _primary;
  }

  @override
  Color primaryLight() {
    return _primaryLight;
  }
}
