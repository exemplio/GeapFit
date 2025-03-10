// ignore_for_file: depend_on_referenced_packages



class Roles{
  List<Role>? roles;

  Roles({this.roles});

  Roles.fromJson(Map<String, dynamic> json) {
    if(json["roles"]!=null){
      roles = [];
      json['roles'].forEach((v) {
        roles?.add(Role.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = {};
    if (roles != null) {
      json['roles'] = roles?.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Role {
  String? realm;
  String? businessId;
  String? userId;
  String? appName;
  String? appStatus;
  String? appUrl;
  String? appIcon;
  String? scopeName;
  String? scopeId;
  String? name;
  String? ownerName;
  String? ownerEmail;
  String? userName;
  String? userEmail;
  bool? thirdPartyAuthorization;
  List<Views>? views;
  List<String>? scopes;


  Role(
    {this.realm,
      this.businessId,
      this.userId,
      this.appName,
      this.appStatus,
      this.appUrl,
      this.appIcon,
      this.scopeName,
      this.scopeId,
      this.name,
      this.ownerName,
      this.ownerEmail,
      this.userName,
      this.userEmail,
      this.thirdPartyAuthorization,
      this.views,
      this.scopes});

Role.fromJson(Map<String, dynamic> json) {
realm = json['realm'];
businessId = json['business_id'];
userId = json['user_id'];
appName = json['app_name'];
appStatus = json['app_status'];
appUrl = json['app_url'];
appIcon = json['app_icon'];
scopeName = json['scope_name'];
scopeId = json['scope_id'];
name = json['name'];
ownerName = json['owner_name'];
ownerEmail = json['owner_email'];
userName = json['user_name'];
userEmail = json['user_email'];
thirdPartyAuthorization = json['third_party_authorization'];
if (json['views'] != null) {
  views = [];
  json['views'].map((v) {
    views?.add(Views.fromJson(v));
  });
}
if (json['scopes'] != null) {
  scopes = [];
  json['scopes'].map((v) {
    scopes?.add(v);
  });
}
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['realm'] = realm;
  data['business_id'] = businessId;
  data['user_id'] = userId;
  data['app_name'] = appName;
  data['app_status'] = appStatus;
  data['app_url'] = appUrl;
  data['app_icon'] = appIcon;
  data['scope_name'] = scopeName;
  data['scope_id'] = scopeId;
  data['name'] = name;
  data['owner_name'] = ownerName;
  data['owner_email'] = ownerEmail;
  data['user_name'] = userName;
  data['user_email'] = userEmail;
  data['third_party_authorization'] = thirdPartyAuthorization;
  if (views != null) {
    data['views'] = views?.map((v) => v.toJson()).toList();
  }
  if (scopes != null) {
    data['scopes'] = scopes?.map((v) => v).toList();
  }
  return data;
}
}
class Actions {
  String? name;
  int? sort;
  String? functionalityDetail;
  String? type;
  String? status;
  String? functionName;
  List<String>? scopes;

  Actions(
      {this.name,
        this.sort,
        this.functionalityDetail,
        this.type,
        this.status,
        this.functionName,
        this.scopes});

  Actions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sort = json['sort'];
    functionalityDetail = json['functionality_detail'];
    type = json['type'];
    status = json['status'];
    functionName = json['function_name'];
    if (json['scopes'] != null) {
      scopes = [];
      json['scopes'].map((v) {
        scopes?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['sort'] = sort;
    data['functionality_detail'] = functionalityDetail;
    data['type'] = type;
    data['status'] = status;
    data['function_name'] = functionName;
    if (scopes != null) {
      data['scopes'] = scopes?.map((v) => v).toList();
    }
    return data;
  }
}
class Views {
  String? name;
  String? functionality;
  String? url;
  String? type;
  String? tag;
  int? sort;
  List<Actions>? actions;

  Views(
      {this.name,
        this.functionality,
        this.url,
        this.type,
        this.tag,
        this.sort,
        this.actions});

  Views.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    functionality = json['functionality'];
    url = json['url'];
    type = json['type'];
    tag = json['tag'];
    sort = json['sort'];
    if (json['actions'] != null) {
      actions = [];
      json['actions'].map((v) {
        actions?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['functionality'] = functionality;
    data['url'] = url;
    data['type'] = type;
    data['tag'] = tag;
    data['sort'] = sort;
    if (actions != null) {
      data['actions'] = actions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}