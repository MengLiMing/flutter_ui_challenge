import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomShowLoadingController with ChangeNotifier {
  var _isLoading = false;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}

class CustomShowLoading extends StatefulWidget {
  final Widget child;
  final CustomShowLoadingController controller;

  /// 背景是否点击
  final bool ignoreBg;

  const CustomShowLoading({
    Key? key,
    required this.child,
    required this.controller,
    this.ignoreBg = false,
  }) : super(key: key);

  @override
  State<CustomShowLoading> createState() => _CustomShowLoadingState();
}

class _CustomShowLoadingState extends State<CustomShowLoading> {
  late ValueNotifier<bool> isLoading;

  CustomShowLoadingController get controller => widget.controller;

  final duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    isLoading = ValueNotifier(controller.isLoading);
    addListener();
  }

  void addListener() {
    controller.addListener(() => isLoading.value = controller.isLoading);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomShowLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.dispose();
      addListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, value, child) {
            final loading = Center(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: 80,
                height: 80,
                child: const CupertinoActivityIndicator(color: Colors.white),
              ),
            );
            final bg = AnimatedOpacity(
              opacity: value ? 1 : 0,
              duration: duration,
              child: loading,
            );
            return Stack(
              fit: StackFit.expand,
              children: [
                IgnorePointer(
                  ignoring: widget.ignoreBg || !value,
                  child: child,
                ),
                bg,
              ],
            );
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {},
            child: const SizedBox.expand(
              child: ColoredBox(color: Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}
