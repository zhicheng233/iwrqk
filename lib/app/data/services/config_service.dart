import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/const/widget.dart';
import '../models/settings/filter_setting.dart';
import '../providers/storage_provider.dart';

abstract class ConfigKey {
  static const String firstRun = "firstRun";
  static const String themeMode = "themeMode";
  static const String localeCode = "localeCode";
  static const String filterSetting = "filterSetting";
  static const String adultCoverBlur = "adultCoverBlur";
}

class ConfigService extends GetxService {
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  late bool firstLoad;

  ThemeMode get themeMode => _themeMode.value;

  set themeMode(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    Get.changeThemeMode(themeMode);
    StorageProvider.setConfig(ConfigKey.themeMode, themeMode.index);
  }

  final RxBool _audltCoverBlur = false.obs;

  bool get adultCoverBlur => _audltCoverBlur.value;

  set adultCoverBlur(bool audltCoverBlur) {
    _audltCoverBlur.value = audltCoverBlur;
    StorageProvider.setConfig(ConfigKey.adultCoverBlur, audltCoverBlur);
  }

  final Rx<FilterSettingModel> _filterSetting = FilterSettingModel().obs;

  FilterSettingModel get filterSetting => _filterSetting.value;

  set filterSetting(FilterSettingModel filterSetting) {
    _filterSetting.value = filterSetting;
    StorageProvider.setConfig(ConfigKey.filterSetting, filterSetting.toJson());
  }

  final RxString _localeCode = "en".obs;

  Locale? get locale {
    if (_localeCode.value.isEmpty) {
      return null;
    }
    return formatLocale(_localeCode.value);
  }

  String get localeCode => _localeCode.value;

  set localeCode(String code) {
    _localeCode.value = code;
    StorageProvider.setConfig(ConfigKey.localeCode, code);
  }

  Locale formatLocale(String locale) {
    if (locale.contains("_")) {
      final localeList = locale.split("_");
      return Locale(localeList[0], localeList[1]);
    }
    return Locale(locale);
  }

  late double gridChildAspectRatio;

  void calculateGridChildAspectRatio(BuildContext context) {
    var width = (MediaQuery.of(context).size.width - 3 * 8) / 2;
    var height = width * 9 / 16 + WidgetConst.mediaPreviewTitleHeight;
    gridChildAspectRatio = width / height;
  }

  @override
  void onInit() {
    super.onInit();
    if (StorageProvider.getConfigByKey(ConfigKey.firstRun) == null) {
      firstLoad = true;
      StorageProvider.setConfig(ConfigKey.firstRun, false);
    } else {
      firstLoad = false;
    }
    if (!firstLoad) {
      _localeCode.value =
          StorageProvider.getConfigByKey(ConfigKey.localeCode) ?? "en";
    }
    _themeMode.value = ThemeMode
        .values[StorageProvider.getConfigByKey(ConfigKey.themeMode) ?? 0];
    _audltCoverBlur.value =
        StorageProvider.getConfigByKey(ConfigKey.adultCoverBlur) ?? false;
  }

  Locale? localeListResolutionCallback(
      List<Locale>? locales, Iterable<Locale> supportedLocales) {
    String? cachedLocale = StorageProvider.getConfigByKey(ConfigKey.localeCode);
    if (cachedLocale != null) {
      return formatLocale(cachedLocale);
    }
    if (locales != null) {
      for (final locale in locales) {
        if (supportedLocales.contains(locale)) {
          StorageProvider.setConfig(ConfigKey.localeCode, locale.toString());
          _localeCode.value = locale.toString();
          return locale;
        }
      }
    }
    return const Locale("en");
  }
}
