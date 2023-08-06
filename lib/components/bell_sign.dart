import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rfw/formats.dart';
import 'package:rfw/rfw.dart';
import 'package:ui/ui.dart';
import 'package:path/path.dart' as path;

class BellSign extends StatefulWidget {
  final File sign;
  final void Function(
    String eventName,
    Map<String, Object?> eventArgs,
  )? onEvent;

  const BellSign({
    required this.sign,
    this.onEvent,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _Sign();
}

class _Sign extends State<BellSign> {
  final Runtime _runtime = Runtime();
  final DynamicContent _content = DynamicContent();

  Widget _native(BuildContext context) {
    return FutureBuilder(
      future: widget.sign.exists(),
      builder: (context, snapshot) {
        bool? fileExists = snapshot.data;
        if (fileExists == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!fileExists) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text("Houh, looks like something went wron!"),
            ],
          );
        }

        return FutureBuilder(
          future: widget.sign.readAsString(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Icon(
                  Icons.sync_problem,
                  color: Colors.red,
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            String rfw = snapshot.data!;

            RemoteWidgetLibrary rwidget;
            try {
              rwidget = parseLibraryFile(rfw);
            } on ParserException catch (exception) {
              stdout.writeln(
                "Error on creating Sing: ${widget.sign.path}: ${exception.toString()}",
              );
              return Text(exception.toString());
            }
            _runtime.update(
              const LibraryName(<String>['core', 'widgets']),
              createCoreWidgets(),
            );
            _runtime.update(
              const LibraryName(<String>['dieKlingel']),
              createDieklingelWidgets(),
            );
            _runtime.update(
              const LibraryName(<String>['main']),
              rwidget,
            );

            return runZoned<RemoteWidget>(() {
              Directory.current = path.dirname(widget.sign.path);

              return RemoteWidget(
                runtime: _runtime,
                widget: const FullyQualifiedWidgetName(
                  LibraryName(['main']),
                  'root',
                ),
                data: _content,
                onEvent: (eventName, eventArguments) {
                  widget.onEvent?.call(eventName, eventArguments);
                },
              );
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _native(context);
  }
}
