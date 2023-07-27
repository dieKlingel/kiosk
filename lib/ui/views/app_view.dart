import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kiosk/repositories/app_repository.dart';

import '../blocs/app_view_bloc.dart';
import '../blocs/passcode_view_bloc.dart';
import '../blocs/sign_list_view_bloc.dart';
import '../../components/activity_listener.dart';
import '../../repositories/sign_repository.dart';
import '../states/app_state.dart';
import '../../utils/touch_scroll_behavior.dart';
import 'home_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppViewBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        return Container(
          color: Colors.black,
          padding: state.clip,
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(20),
            child: const _Viewport(),
          ),
        );
      },
    );
  }
}

class _Viewport extends StatelessWidget {
  const _Viewport();

  @override
  Widget build(BuildContext context) {
    return ActivityListener(
      onActivity: () {
        context.read<AppViewBloc>().interact();
      },
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        scrollBehavior: TouchScrollBehavior(),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => PasscodeViewBloc(
                GetIt.I<AppRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => SignListViewBloc(
                GetIt.I<AppRepository>(),
                GetIt.I<SignRepository>(),
              ),
            )
          ],
          child: const HomeView(),
        ),
      ),
    );
  }
}
