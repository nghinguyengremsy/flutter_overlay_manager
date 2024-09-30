import 'package:flutter/material.dart';

enum OverlayLayoutTypeEnum {
  dialog,
  custom,
}

class OverlayLayout extends StatefulWidget {
  const OverlayLayout({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.transparent,
    required this.type,
  });
  final Widget child;
  final Function()? onTap;
  final Color backgroundColor;
  final OverlayLayoutTypeEnum type;
  @override
  State<OverlayLayout> createState() => OverlayLayoutState();
}

class OverlayLayoutState extends State<OverlayLayout>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(controller);
    animationFoward();
  }

  TickerFuture animationFoward() {
    return controller.forward();
  }

  TickerFuture animationReverse() {
    return controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildWithType();
  }

  Widget buildWithType() {
    switch (widget.type) {
      case OverlayLayoutTypeEnum.dialog:
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: _animation,
            curve: Curves.easeOut,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  color: widget.backgroundColor,
                ),
              ),
              widget.child,
            ],
          ),
        );
      default:
        return widget.child;
    }
  }
}
