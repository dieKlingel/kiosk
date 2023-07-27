import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/app_repository.dart';
import '../states/app_state.dart';

class AppViewBloc extends Cubit<AppState> {
  final AppRepository appRepository;

  Timer? _timer;

  AppViewBloc(this.appRepository) : super(AppState()) {
    interact();
    init();
  }

  Future<void> init() async {
    EdgeInsets clip = await appRepository.fetchViewportClip();
    emit(state.copyWith(clip: clip));
  }

  Future<void> interact() async {
    if (!(_timer?.isActive ?? false)) {
      //client.publish(Message("io/display/state", "on"));
      emit(state.copyWith(display: DisplayState.on));
    }

    _timer?.cancel();
    Duration timeout = await appRepository.fetchScreenTimeout();
    _timer = Timer(timeout, _onTimeout);
  }

  void _onTimeout() {
    //client.publish(Message("io/display/state", "off"));
    emit(state.copyWith(display: DisplayState.off));
  }
}
