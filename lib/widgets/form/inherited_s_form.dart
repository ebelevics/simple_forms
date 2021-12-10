part of 's_form.dart';

class _InheritedSForm extends InheritedWidget {
  final SimpleForm form;
  final SForm sForm;

  const _InheritedSForm({
    Key? key,
    required this.form,
    required this.sForm,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedSForm old) => form != old.form;
}
