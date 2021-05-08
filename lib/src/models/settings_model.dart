import 'package:flutter_app/src/domain/constants.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SettingsModel {
  SettingsModel(StreamingSharedPreferences preferences)
      : countryCode =
            preferences.getString(KEY_COUNTRY_CODE_SETTINGS, defaultValue: "");

  final Preference<String> countryCode;
}
