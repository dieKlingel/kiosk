import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/models/action_execute_request.dart';
import 'package:kiosk/repositories/app_repository.dart';
import 'package:logger/logger.dart';
import 'package:mqtt/mqtt.dart';

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
    MqttHttpClient client = MqttHttpClient();
    Uri uri = await appRepository.fetchMqttUri();
    String username = await appRepository.fetchMqttUsername();
    String password = await appRepository.fetchMqttPassword();
    try {
      await client.post(
        uri.resolve("actions/execute"),
        headers: {"username": username, "password": password},
        body: jsonEncode(
          ActionExecuteRequest(
            "ring",
            environment: {
              "SIGN": sign,
            },
          ).toMap(),
        ),
      );
    } on TimeoutException catch (e) {
      Logger.warn(e.message ?? "timeout exception");
    }
  }
}
