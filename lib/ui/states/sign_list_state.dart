import 'dart:io';

class SignListState {
  final List<File> signs;
  final bool isLoading;

  SignListState._({
    this.signs = const [],
    this.isLoading = false,
  });

  factory SignListState.loading() {
    return SignListState._(isLoading: true);
  }

  factory SignListState.signs(List<File> signs) {
    return SignListState._(signs: signs);
  }
}
