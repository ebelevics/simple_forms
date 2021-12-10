// ignore_for_file: unnecessary_this, prefer_initializing_formals, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_forms/models/field_control/abstract_field_control.dart';
import 'package:simple_forms/widgets/form/s_form.dart';
import 'package:simple_forms/widgets/widgets/s_error_widget.dart';

class SFormField<T> extends StatefulWidget {
  final String name;
  final Widget Function(
    BuildContext context,
    AbstractFieldControl<T, dynamic> control,
    Map<String, AbstractFieldControl> controls,
  ) child;
  final Widget Function(List<String> errors)? errorWidget;
  final EdgeInsets? errorPadding;
  final bool hideError;

  SFormField({
    Key? key,
    required this.name,
    required this.child,
    this.errorWidget,
    this.errorPadding,
    this.hideError = false,
  }) : super(key: key);

  late final List<String>? names;

  SFormField.combined({
    Key? key,
    required List<String> names,
    required this.child,
    this.errorWidget,
    this.errorPadding,
    this.hideError = false,
  })  : name = names.first,
        this.names = names,
        super(key: key);

  @override
  _SFormFieldState<T> createState() => _SFormFieldState<T>();
}

class _SFormFieldState<T> extends State<SFormField<T>> {
  late SForm sForm;
  late AbstractFieldControl<T, dynamic> control;
  late Map<String, AbstractFieldControl> fieldControls;

  late StreamSubscription<T?> _valueSubscription;
  late StreamSubscription<ControlStatus> _statusSubscription;
  late StreamSubscription<bool> _focusSubscription;

  @override
  void initState() {
    control = _findFieldControl();
    control.attachContext(context);
    _subscribeToFieldControl();
    super.initState();
  }

  @override
  void dispose() {
    _cancelFieldControlSubscriptions();
    control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: (_) {
        print("object");
      },
      onTapDown: (_) {
        print("object1");
      },
      onTap: () {
        print("object2");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.child(context, control, fieldControls),
          if (control.errors != null && !widget.hideError)
            widget.errorWidget != null
                ? widget.errorWidget!(control.errors!)
                : sForm.errorWidget != null
                    ? sForm.errorWidget!(control.errors!)
                    : SErrorWidget(
                        errorText: control.errors!.first,
                        padding: widget.errorPadding ?? sForm.errorPadding,
                      ),
        ],
      ),
    );
  }

  AbstractFieldControl<T, dynamic> _findFieldControl() {
    final form = SForm.of(context);
    final sForm = SForm.get(context);
    if (form == null || sForm == null) throw ("needs SForm as parent widget");
    this.sForm = sForm;
    this.fieldControls = form.fieldControls;

    final control = fieldControls[widget.name];
    if (control == null) throw ("needs proper name that exists in SFrom");

    if (control is AbstractFieldControl<T, dynamic>) {
      return control;
    } else {
      throw ("double check does SimpleForm field view type match with SFormField view type");
    }
  }

  void _subscribeToFieldControl() {
    _valueSubscription = control.valueStream.listen((value) => setState(() => {}));
    _statusSubscription = control.statusStream.listen((value) => setState(() => {}));
    _focusSubscription = control.focusStream.listen((value) => setState(() => {}));
  }

  void _cancelFieldControlSubscriptions() {
    _valueSubscription.cancel();
    _statusSubscription.cancel();
    _focusSubscription.cancel();
  }
}
