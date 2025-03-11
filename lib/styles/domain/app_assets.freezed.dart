// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_assets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppAssets _$AppAssetsFromJson(Map<String, dynamic> json) {
  return _AppAssets.fromJson(json);
}

/// @nodoc
mixin _$AppAssets {
  String get uri => throw _privateConstructorUsedError;
  String get logo => throw _privateConstructorUsedError;
  String get logo2 => throw _privateConstructorUsedError;
  String get logo3 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppAssetsCopyWith<AppAssets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppAssetsCopyWith<$Res> {
  factory $AppAssetsCopyWith(AppAssets value, $Res Function(AppAssets) then) =
      _$AppAssetsCopyWithImpl<$Res, AppAssets>;
  @useResult
  $Res call(
      {String uri,
      String logo,
      String logo2,
      String logo3,
      });
}

/// @nodoc
class _$AppAssetsCopyWithImpl<$Res, $Val extends AppAssets>
    implements $AppAssetsCopyWith<$Res> {
  _$AppAssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? logo = null,
    Object? logo2 = null,
    Object? logo3 = null,
  }) {
    return _then(_value.copyWith(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      logo2: null == logo2
          ? _value.logo2
          : logo2 // ignore: cast_nullable_to_non_nullable
              as String,
      logo3: null == logo3
          ? _value.logo3
          : logo3 // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppAssetsCopyWith<$Res> implements $AppAssetsCopyWith<$Res> {
  factory _$$_AppAssetsCopyWith(
          _$_AppAssets value, $Res Function(_$_AppAssets) then) =
      __$$_AppAssetsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uri,
      String logo,
      String logo2,
      String logo3,
      });
}

/// @nodoc
class __$$_AppAssetsCopyWithImpl<$Res>
    extends _$AppAssetsCopyWithImpl<$Res, _$_AppAssets>
    implements _$$_AppAssetsCopyWith<$Res> {
  __$$_AppAssetsCopyWithImpl(
      _$_AppAssets _value, $Res Function(_$_AppAssets) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uri = null,
    Object? logo = null,
    Object? logo2 = null,
    Object? logo3 = null,
  }) {
    return _then(_$_AppAssets(
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      logo2: null == logo2
          ? _value.logo2
          : logo2 // ignore: cast_nullable_to_non_nullable
              as String,
      logo3: null == logo3
          ? _value.logo3
          : logo3 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class _$_AppAssets implements _AppAssets {
  const _$_AppAssets(
      {required this.uri,
      required this.logo,
      required this.logo2,
      required this.logo3,
      });

  factory _$_AppAssets.fromJson(Map<String, dynamic> json) =>
      _$$_AppAssetsFromJson(json);

  @override
  final String uri;
  @override
  final String logo;
  @override
  final String logo2;
  @override
  final String logo3;

  @override
  String toString() {
    return 'AppAssets(uri: $uri, logo: $logo, logo2: $logo2, logo3: $logo3)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppAssets &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.logo2, logo2) || other.logo2 == logo2) &&
            (identical(other.logo3, logo3) || other.logo3 == logo3));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uri, logo, logo2, logo3);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppAssetsCopyWith<_$_AppAssets> get copyWith =>
      __$$_AppAssetsCopyWithImpl<_$_AppAssets>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppAssetsToJson(
      this,
    );
  }
}

abstract class _AppAssets implements AppAssets {
  const factory _AppAssets(
      {required final String uri,
      required final String logo,
      required final String logo2,
      required final String logo3,
      }) = _$_AppAssets;

  factory _AppAssets.fromJson(Map<String, dynamic> json) =
      _$_AppAssets.fromJson;

  @override
  String get uri;
  @override
  String get logo;
  @override
  String get logo2;
  @override
  String get logo3;
  @override
  @JsonKey(ignore: true)
  _$$_AppAssetsCopyWith<_$_AppAssets> get copyWith =>
      throw _privateConstructorUsedError;
}
