import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_weather_client/open_weather.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'src/app/app.dart';
import 'src/app/app_model.dart';
import 'src/locations/locations_service.dart';
import 'src/weather/weather_model.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  final apiKey = await loadApiKey();
  di.registerSingleton<OpenWeather>(OpenWeather(apiKey: apiKey ?? ''));

  final locationsService = LocationsService();
  await locationsService.init();
  di.registerSingleton<LocationsService>(
    locationsService,
    dispose: (s) => s.dispose(),
  );
  final appModel = AppModel(connectivity: Connectivity());
  await appModel.init();
  di.registerSingleton(appModel);

  di.registerLazySingleton(
    () => WeatherModel(
      locationsService: di<LocationsService>(),
      openWeather: di<OpenWeather>(),
    ),
    dispose: (s) => s.dispose(),
  );

  runApp(const App());
}

Future<String?> loadApiKey() async {
  final source = await rootBundle.loadString('assets/apikey.json');
  final json = jsonDecode(source);
  return json['apiKey'] as String;
}
