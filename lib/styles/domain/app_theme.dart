// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geap_fit/styles/domain/app_assets.dart';
import 'package:geap_fit/styles/domain/app_colors.dart';

part 'app_theme.freezed.dart';
part 'app_theme.g.dart';

@freezed
class AppTheme with _$AppTheme {
  @JsonSerializable(
    explicitToJson: true,
    fieldRename: FieldRename.snake,
    includeIfNull: false,
  )
  const factory AppTheme({
    required String name,
    @Default(false) bool dflt,
    required AppColors colors,
    required AppAssets assetsImg,
  }) = _AppTheme;

  factory AppTheme.fromJson(Map<String, Object?> json) =>
      _$AppThemeFromJson(json);
}
