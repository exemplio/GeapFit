// ignore_for_file: file_names

class ColorModel {
  String? idDoc;
  String? name;
  Colors? colors;
  AssetsImg? assetsImg;

  ColorModel({this.idDoc, this.colors, this.assetsImg, this.name});

  ColorModel.fromJson(Map<String, dynamic> json) {
    idDoc = json['idDoc'];
    name = json['name'];
    colors =
    json['colors'] != null ? Colors.fromJson(json['colors']) : null;
    assetsImg = json['assets_img'] != null
        ? AssetsImg.fromJson(json['assets_img'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idDoc'] = idDoc;
    data['name'] = name;
    if (colors != null) {
      data['colors'] = colors!.toJson();
    }
    if (assetsImg != null) {
      data['assets_img'] = assetsImg!.toJson();
    }
    return data;
  }
}

class Colors {
  String? primary;
  String? primaryLight;

  Colors({this.primary, this.primaryLight});

  Colors.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    primaryLight = json['primary_light'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primary'] = primary;
    data['primary_light'] = primaryLight;
    return data;
  }
}

class AssetsImg {
  String? uri;
  String? logo;
  String? logo2;
  String? logo3;

  AssetsImg(
      {this.uri,
        this.logo,
        this.logo2,
        this.logo3,
        });

  AssetsImg.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    logo = json['logo'];
    logo2 = json['logo2'];
    logo3 = json['logo3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uri'] = uri;
    data['logo'] = logo;
    data['logo2'] = logo2;
    data['logo3'] = logo3;
    return data;
  }
}
