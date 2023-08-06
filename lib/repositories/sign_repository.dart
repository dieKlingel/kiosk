import 'dart:io';

class SignRepository {
  Future<List<File>> fetchAllSigns() async {
    String? env = Platform.environment["DIEKLINGEL_HOME"];
    if (env == null || env.isEmpty) {
      return List.empty();
    }
    if (!await Directory(env).exists()) {
      return List.empty();
    }

    List<FileSystemEntity> files =
        await Directory(env).list(followLinks: false).toList();
    files.sort((FileSystemEntity first, FileSystemEntity second) {
      return second.path.compareTo(first.path);
    });

    List<File> signs = [];

    for (FileSystemEntity file in files) {
      if (!file.path.endsWith(".rfwtxt")) {
        continue;
      }
      File rfwfile = File(file.path);
      signs.add(rfwfile);
    }

    return signs;
  }
}
