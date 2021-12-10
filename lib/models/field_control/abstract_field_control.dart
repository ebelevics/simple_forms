import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_forms/converters/simple_converters.dart';
import 'package:simple_forms/validators/field_validators.dart';

enum ControlStatus { valid, invalid, disabled }

abstract class AbstractFieldControl<ViewT, DataT> {
  late ViewT? initValue;
  final List<FieldValidator<ViewT>> Function(AbstractFieldControl control, BuildContext? ctx)?
      validators;
  final List<Future<FormFieldValidator<ViewT>>> asyncValidators;
  final bool includeIfNull;
  final SimpleConverter<ViewT?, DataT?> convertToData;

  AbstractFieldControl({
    this.initValue,
    this.validators,
    this.asyncValidators = const [],
    this.includeIfNull = false,
    required this.convertToData,
  }) {
    _value = initValue;
  }

  final _statusController = StreamController<ControlStatus>.broadcast();
  final _valueController = StreamController<ViewT?>.broadcast();
  final _focusController = StreamController<bool>.broadcast();

  Stream<ControlStatus> get statusStream => _statusController.stream;
  Stream<ViewT?> get valueStream => _valueController.stream;
  Stream<bool> get focusStream => _focusController.stream;

  ViewT? _value;
  ViewT? get value => _value;
  set value(ViewT? newValue) {
    _valueController.add(newValue);
    if (_value != newValue) {
      _value = newValue;
      validate();
    }
  }

  FutureOr<DataT?> get data => convertToData(_value);
  String? get validatedValue {
    if (validators != null) {
      for (final validator in validators!(this, _context)) {
        final error = validator(_value);
        if (error != null) return error;
      }
    }
  }

  List<String> _errors = <String>[];
  List<String>? get errors => _errors.isNotEmpty ? _errors : null;
  BuildContext? _context;

  attachContext(BuildContext? context) => _context = context;

  void dispose() {
    _statusController.close();
    _valueController.close();
    _focusController.close();
    _context = null;
  }

  void scrollToFieldWidget([Duration duration = const Duration(milliseconds: 400)]) {
    if (_context != null) {
      Scrollable.ensureVisible(_context!, duration: duration, curve: Curves.easeInOut);
    }
  }

  void reset() {
    _valueController.add(initValue);
    _statusController.add(ControlStatus.valid);
  }

  List<String> validate([BuildContext? context]) {
    final errors = <String>[];
    final error = validatedValue;
    if (error != null) errors.add(error);
    _errors = errors;
    return errors;
  }
}
