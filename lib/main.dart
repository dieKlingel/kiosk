import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kiosk/models/request.dart';
import 'package:mqtt/mqtt.dart';
import 'package:path/path.dart' as path;

import 'ui/blocs/app_view_bloc.dart';
import 'repositories/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/sign_repository.dart';
import 'ui/views/app_view.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.environment["DIEKLINGEL_HOME"] != null) {
    Directory.current = Platform.environment["DIEKLINGEL_HOME"];
  }

  GetIt.I
    ..registerSingleton(AppRepository())
    ..registerSingleton(SignRepository());

  Uri uri = await GetIt.I<AppRepository>().fetchMqttUri();
  String username = await GetIt.I<AppRepository>().fetchMqttUsername();
  String password = await GetIt.I<AppRepository>().fetchMqttPassword();

  MqttClient client = MqttClient(uri);
  try {
    await client.connect(username: username, password: password);

    client.publish(
      path.normalize("./${uri.path}/apps/kiosk"),
      Request(
          "GET",
          jsonEncode({
            "event-type": "boot",
          })).toJsonString(),
    );
  } catch (e) {
    stderr.writeln(e.toString());
  }

  GetIt.I.registerSingleton(client);

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => AppViewBloc(GetIt.I<AppRepository>()))
      ],
      child: const App(),
    ),
  );
}
