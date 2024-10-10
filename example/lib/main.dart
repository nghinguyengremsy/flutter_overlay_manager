import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_manager/flutter_overlay_manager.dart';

void main() {
  FlutterOverlayManager.I.setLoadingZIndex(0);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        return FlutterOverlayManager.I.builder((context) => child!);
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(
              onPressed: () async {
                final loader = await FlutterOverlayManager.I.showLoading();
                await Future.delayed(Duration(seconds: 5));
                await loader.dismiss();
              },
              child: Text("Long-running task"),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                if (FlutterOverlayManager.I
                    .isOverlayShowing("_TOP_OVERLAY_ID")) {
                  FlutterOverlayManager.I.hide("_TOP_OVERLAY_ID");
                } else {
                  FlutterOverlayManager.I.show(
                    (context) => const Positioned(
                      top: 200,
                      right: 0,
                      child: TopOverlayView(),
                    ),
                    zindex: 1, // The overlay loading will be below the overlay
                    id: "_TOP_OVERLAY_ID",
                  );
                }
                setState(() {});
              },
              child: Text(
                  FlutterOverlayManager.I.isOverlayShowing("_TOP_OVERLAY_ID")
                      ? "Hide Top Overlay"
                      : "Show Top Overlay"),
            ),
          ],
        ),
      ),
    );
  }
}

class TopOverlayView extends StatefulWidget {
  const TopOverlayView({super.key});

  @override
  State<TopOverlayView> createState() => _TopOverlayViewState();
}

class _TopOverlayViewState extends State<TopOverlayView> {
  var _color = Colors.yellow;
  void _randomColor() {
    final random = Random();
    _color = Colors.primaries[random.nextInt(Colors.primaries.length)];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: _color,
          width: 50,
          height: 50,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            _randomColor();
          },
          child: Text("Click to change color"),
        ),
      ],
    );
  }
}
