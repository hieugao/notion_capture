// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final sharedPreferencesServiceProvider =
//     Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

// class SharedPreferencesService {
//   SharedPreferencesService(this.sharedPreferences);

//   final SharedPreferences sharedPreferences;

//   // static const onboardingCompleteKey = 'onboardingComplete';
//   static const notesKey = 'notes';

//   void setData(String key, String json) {
//     sharedPreferences.setString(key, json);
//   }

//   String getData(String key) {
//     return sharedPreferences.getString(key) ?? '';
//   }

//   // Future<void> setOnboardingComplete() async {
//   //   await sharedPreferences.setBool(onboardingCompleteKey, true);
//   // }

//   // bool isOnboardingComplete() =>
//   //     sharedPreferences.getBool(onboardingCompleteKey) ?? false;
// }
