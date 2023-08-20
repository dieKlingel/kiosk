import 'dart:io';

import 'package:flutter/material.dart';

class SimpleSign extends StatefulWidget {
  final String text;
  final String? audio;
  final double height;
  final Color backgroundColor;
  final void Function()? onTap;

  const SimpleSign({
    required this.text,
    required this.height,
    required this.backgroundColor,
    this.audio,
    this.onTap,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SimpleSign();
}

class _SimpleSign extends State<SimpleSign>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        widget.onTap?.call();
        String? audiofile = widget.audio;

        if (audiofile != null && audiofile.isNotEmpty) {
          Process.run("gsound-play", ["-f", audiofile]).then((value) {
            if (value.exitCode != 0) {
              stdout.write(value.stdout);
              stderr.write(value.stderr);
            }
          });
        }
        await _controller.forward(from: 0);
      },
      child: Container(
        width: double.infinity,
        color: widget.backgroundColor,
        height: widget.height,
        padding: EdgeInsets.all(
          widget.height / 100,
          //MediaQuery.of(context).size.height * widget.height / 100 / 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(top: widget.height / 5),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: widget.height / 35,
                    child: RotationTransition(
                      alignment: Alignment.topCenter,
                      turns: TweenSequence([
                        TweenSequenceItem(
                          tween: Tween(begin: 0.0, end: -0.02),
                          weight: 1.0,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: -0.02, end: 0.02),
                          weight: 1.2,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: 0.02, end: -0.02),
                          weight: 1.2,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: -0.02, end: 0.02),
                          weight: 0.6,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: 0.01, end: 0.0),
                          weight: 0.2,
                        )
                      ]).animate(_controller),
                      child: Image.asset(
                        "assets/images/clapper.png",
                        fit: BoxFit.fitHeight,
                        height: widget.height / 4,
                        package: "ui",
                      ),
                    ),
                  ),
                  Positioned(
                    child: RotationTransition(
                      alignment: Alignment.topCenter,
                      turns: TweenSequence([
                        TweenSequenceItem(
                          tween: Tween(begin: 0.0, end: 0.04),
                          weight: 1.0,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: 0.04, end: -0.03),
                          weight: 1.2,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: -0.03, end: 0.03),
                          weight: 1.2,
                        ),
                        TweenSequenceItem(
                          tween: Tween(begin: 0.02, end: 0.0),
                          weight: 0.8,
                        )
                      ]).animate(_controller),
                      child: Image.asset(
                        "assets/images/bell.png",
                        fit: BoxFit.fitHeight,
                        height: widget.height / 4,
                        package: "ui",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.text,
              style: const TextStyle(fontSize: 55),
            ),
          ],
        ),
      ),
    );
  }
}
