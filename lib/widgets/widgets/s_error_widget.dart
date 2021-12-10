import 'package:flutter/material.dart';

class SErrorWidget extends StatefulWidget {
  final String errorText;
  final EdgeInsets? padding;
  const SErrorWidget({Key? key, required this.errorText, this.padding})
      : super(key: key);
  @override
  _SErrorWidgetState createState() => _SErrorWidgetState();
}

class _SErrorWidgetState extends State<SErrorWidget>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200))
    ..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Text(
        widget.errorText,
        style: Theme.of(context).inputDecorationTheme.errorStyle ??
            const TextStyle(color: Colors.red, fontSize: 12),
      ),
      builder: (context, child) {
        return Container(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          width: double.infinity,
          child: Opacity(
            opacity: _controller.value,
            child: FractionalTranslation(
              translation: Tween<Offset>(
                begin: const Offset(0.0, -0.25),
                end: Offset.zero,
              ).evaluate(_controller.view),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
