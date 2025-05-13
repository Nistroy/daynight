import 'package:daynight/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State qui permet d'alterner entre le jour et la nuit
final dayNightProvider = StateNotifierProvider<DayNightNotifier, bool>((ref) {
  return DayNightNotifier();
});

class DayNightNotifier extends StateNotifier<bool> {
  DayNightNotifier()
    : super(PreferencesService().getDayNightPreference() == DayNightEnum.day);

  void toggle() {
    state = !state;
  }
}

// Là c'est le provider dont on initialise la valeur avec la préférence de jour ou nuit
// Pourquoi faire un provider ? C'est pour DropdownButton et utiliser un consumer sur ce provider
final dayNightPreferenceProvider =
    StateNotifierProvider<DayNightPreferenceNotifier, DayNightEnum>((ref) {
      return DayNightPreferenceNotifier();
    });

// State qui gère la préférence de jour ou nuit
class DayNightPreferenceNotifier extends StateNotifier<DayNightEnum> {
  DayNightPreferenceNotifier()
    : super(PreferencesService().getDayNightPreference());

  void setPreference(DayNightEnum preference) async {
    state = preference;
    await PreferencesService().setDayNightPreference(preference);
  }
}

class DayNight extends ConsumerStatefulWidget {
  const DayNight({super.key});

  @override
  ConsumerState<DayNight> createState() => _DayNightState();
}

class _DayNightState extends ConsumerState<DayNight> {
  bool _day = true;

  @override
  Widget build(BuildContext context) {
    // On fait pas _day = ref.watch(dayNightProvider); car on rebuild déjà dans MainApp
    _day = ref.read(dayNightProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _day ? "Day" : "Night",
          style: TextStyle(fontFamily: "ShareTech"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Thème par défaut :"),

            // Consumer pour la préférence de jour ou nuit (qui est initialisée au démarrage)
            Consumer(
              builder: (context, ref, child) {
                final preference = ref.watch(dayNightPreferenceProvider);
                return DropdownButton<DayNightEnum>(
                  value: preference,
                  items:
                      DayNightEnum.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toString()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(dayNightPreferenceProvider.notifier)
                          .setPreference(value);
                    }
                  },
                );
              },
            ),
            Image(
              image: AssetImage(_day ? "images/day.png" : "images/night.png"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPress,
        child: Icon(_day ? Icons.night_shelter : Icons.light),
      ),
    );
  }

  void _onPress() {
    ref.read(dayNightProvider.notifier).toggle();
  }
}

enum DayNightEnum {
  day,
  night;

  @override
  String toString() {
    switch (this) {
      case DayNightEnum.day:
        return "Day";
      case DayNightEnum.night:
        return "Night";
    }
  }

  static DayNightEnum fromString(String value) {
    switch (value) {
      case "Day":
        return DayNightEnum.day;
      case "Night":
        return DayNightEnum.night;
      default:
        throw Exception("Valeur non valide : $value");
    }
  }
}
