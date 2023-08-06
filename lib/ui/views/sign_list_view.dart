import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/app_view_bloc.dart';
import '../blocs/sign_list_view_bloc.dart';
import '../../components/bell_sign.dart';
import '../states/app_state.dart';
import '../states/sign_list_state.dart';

class SignListView extends StatefulWidget {
  const SignListView({super.key});

  @override
  State<SignListView> createState() => _SignListViewState();
}

class _SignListViewState extends State<SignListView>
    with AutomaticKeepAliveClientMixin {
  final _controller = ScrollController();

  void onEvent(String eventName, Map<String, Object?> eventArgs) {
    switch (eventName) {
      case "ring":
        context
            .read<SignListViewBloc>()
            .ring(eventArgs["sign"]?.toString() ?? "");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<AppViewBloc, AppState>(
      listener: (BuildContext context, AppState state) {
        if (state.display.isOff) {
          _controller.jumpTo(0);
        }
      },
      child: Scaffold(
        body: BlocBuilder<SignListViewBloc, SignListState>(
          builder: (BuildContext context, SignListState state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              controller: _controller,
              itemCount: state.signs.length,
              itemBuilder: (context, index) {
                File file = state.signs[index];

                return BellSign(
                  sign: file,
                  onEvent: onEvent,
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
