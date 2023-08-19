import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/models/request.dart';
import 'package:kiosk/repositories/app_repository.dart';
import 'package:mqtt/mqtt.dart';
import 'package:path/path.dart' as path;

import '../states/passcode_state.dart';

class PasscodeViewBloc extends Cubit<PasscodeState> {
  final AppRepository appRepository;

  PasscodeViewBloc(this.appRepository) : super(PasscodeState());

  Future<void> submit(String passcode) async {
    Uri uri = await appRepository.fetchMqttUri();
    MqttClient client = MqttClient(uri);
    try {
      String username = await appRepository.fetchMqttUsername();
      String password = await appRepository.fetchMqttPassword();
      await client.connect(username: username, password: password);
    } catch (e) {
      stderr.writeln(e.toString());
      return;
    }
    client.publish(
      path.normalize("./${uri.path}/actions/execute"),
      Request(
        "GET",
        jsonEncode(
          {
            "pattern": "unlock",
            "environment": {
              "PASSCODE": passcode,
            }
          },
        ),
      ).toJsonString(),
    );
  }
}
