import 'package:daynight/day_night.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  PreferencesService._internal();

  SharedPreferences? _sharedPreferences;

  factory PreferencesService() {
    return _instance;
  }

  DayNightEnum _dayNightPreference = DayNightEnum.day;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final preferenceString = _sharedPreferences?.getString(
      "dayNightPreference",
    );
    if (preferenceString != null) {
      _dayNightPreference = DayNightEnum.values.firstWhere(
        (e) => e.toString() == preferenceString,
        orElse: () => DayNightEnum.day,
      );
    }
  }

  Future<void> setDayNightPreference(DayNightEnum preference) async {
    _dayNightPreference = preference;
    await _sharedPreferences?.setString(
      "dayNightPreference",
      preference.toString(),
    );
  }

  DayNightEnum getDayNightPreference() {
    final preferenceString = _sharedPreferences?.getString(
      "dayNightPreference",
    );
    if (preferenceString != null) {
      return DayNightEnum.values.firstWhere(
        (e) => e.toString() == preferenceString,
      );
    }
    return _dayNightPreference;
  }
}
