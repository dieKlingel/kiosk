import 'dart:io';

import '../models/sign.dart';

class SignRepository {
  Future<List<Sign>> fetchAllSigns() async {
    String? env = Platform.environment["DIEKLINGEL_HOME"];
    if (env == null || env.isEmpty) {
      return List.empty();
    }

    // TODO: fetch signs
    return List.empty();
  }
}
