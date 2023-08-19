import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:kiosk/repositories/app_repository.dart';
import 'package:mqtt/mqtt.dart';

import '../../models/request.dart';
import '../../repositories/sign_repository.dart';
import '../states/sign_list_state.dart';

class SignListViewBloc extends Cubit<SignListState> {
  final AppRepository appRepository;
  final SignRepository signRepository;

  SignListViewBloc(
    this.appRepository,
    this.signRepository,
  ) : super(SignListState.signs([])) {
    refresh();
  }

  Future<void> refresh() async {
    emit(SignListState.loading());
    List<File> signs = await signRepository.fetchAllSigns();

    emit(SignListState.signs(signs));
  }

  Future<void> ring(String sign) async {
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
            "pattern": "ring",
            "environment": {
              "SIGB": sign,
            }
          },
        ),
      ).toJsonString(),
    );
  }
}
