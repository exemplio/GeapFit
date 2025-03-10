import 'package:injectable/injectable.dart';
import 'package:optional/optional.dart';
import 'package:sports_management/domain/profile.dart';
import 'package:sports_management/styles/theme_provider.dart';

@injectable
class ThemeSelector {
  final ThemeProvider _themeProvider;

  ThemeSelector(this._themeProvider);

  void selectThemeFromProfile(Profile profile) {
    var idDoc = profile.idDoc;
    if (idDoc != null) {
      //setThemeFromIdDoc(idDoc);
    }
  }

  void setThemeFromIdDoc(String idDoc) {
    _themeProvider.themes.values
        .where((appTheme) {
          return appTheme.filter.idDocs.contains(idDoc);
        })
        .map((e) => e.name)
        .firstOptional
        .ifPresent(_themeProvider.changeTheme);
  }

  void setThemeFromDeviceJson(Map<String, dynamic> json) async {
    String? sellerIdDoc = json["device"]?["seller_id_doc"];
    if (sellerIdDoc != null) {
      setThemeFromIdDoc(sellerIdDoc);
    }
  }
}
