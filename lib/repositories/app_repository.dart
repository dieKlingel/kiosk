import 'dart:io';

import 'package:flutter/material.dart';

class AppRepository {
  Future<EdgeInsets> fetchViewportClip() async {
    String? clips = Platform.environment["DIEKLINGEL_CLIP"];
    if (clips == null || clips.isEmpty) {
      return EdgeInsets.zero;
    }

    final regex = RegExp("^\\d+,\\d+,\\d+,\\d+\$");

    if (!regex.hasMatch(clips)) {
      stdout.writeln(
        "Canno read DIEKLINGEL_CLIP, format has to be left,top,right,bottom",
      );
      return EdgeInsets.zero;
    }

    List<int> clip = clips.split(",").map((e) => int.parse(e)).toList();

    return EdgeInsets.fromLTRB(
      clip[0].toDouble(),
      clip[1].toDouble(),
      clip[2].toDouble(),
      clip[3].toDouble(),
    );
  }

  Future<Uri> fetchMqttUri() async {
    String rawUri = Platform.environment["DIEKLINGEL_MQTT_URI"] ?? "";
    return Uri.parse(rawUri);
  }

  Future<String> fetchMqttUsername() async {
    String username = Platform.environment["DIEKLINGEL_MQTT_USERNAME"] ?? "";
    return username;
  }

  Future<String> fetchMqttPassword({bool useCache = true}) async {
    String password = Platform.environment["DIEKLINGEL_MQTT_PASSWORD"] ?? "";
    return password;
  }

  Future<Duration> fetchScreenTimeout() async {
    String? timeout = Platform.environment["DIEKLINGEL_TIMEOUT"];
    if (timeout == null || timeout.isEmpty) {
      return const Duration(seconds: 30);
    }

    int seconds = int.tryParse(timeout) ?? 30;

    return Duration(seconds: seconds);
  }
}
