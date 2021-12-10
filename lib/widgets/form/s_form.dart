import 'package:flutter/material.dart';
import 'package:simple_forms/models/simple_form.dart';

part 'inherited_s_form.dart';

class SForm extends StatelessWidget {
  final Widget child;
  final SimpleForm form;
  final Widget Function(List<String> errors)? errorWidget;
  final EdgeInsets? errorPadding;

  const SForm({
    Key? key,
    required this.form,
    required this.child,
    this.errorWidget,
    this.errorPadding,
  }) : super(key: key);

  static SimpleForm? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedSForm>()?.form;
  }

  static SForm? get(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedSForm>()?.sForm;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSForm(form: form, sForm: this, child: child);
  }
}
