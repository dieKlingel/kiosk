library rfw_library;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:rfw/rfw.dart';

import 'components/simple_sign.dart';

WidgetLibrary createDieklingelWidgets() {
  return LocalWidgetLibrary(
    {
      "SimpleSign": (BuildContext context, DataSource source) {
        String text = source.v<String>(<Object>["text"]) ?? "dieKlingel";
        String? audio = source.v<String>(<Object>["audio"]);
        double height = source.v<double>(<Object>["height"]) ?? 1024.0;
        Color color = ArgumentDecoders.color(source, ['color']) ??
            const Color(0xFFFFA424);

        if (audio != null && audio.isNotEmpty) {
          audio = absolute(audio);
        }

        return SimpleSign(
          text: text,
          audio: audio,
          height: height,
          backgroundColor: color,
          onTap: source.voidHandler(['onTap']),
        );
      }
    },
  );
}
