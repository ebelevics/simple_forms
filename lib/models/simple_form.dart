import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_forms/models/field_group.dart';
import 'package:simple_forms/validators/form_validators.dart';

import 'field_control/abstract_field_control.dart';

abstract class SimpleForm {
  final _statusController = StreamController<ControlStatus>.broadcast();
  void dispose() => _statusController.close();

  final Map<String, AbstractFieldControl> fieldControls;
  final Map<String, FieldGroup> fieldGroups;
  final List<FormValidator>? Function(BuildContext? ctx)? formValidators;

  final Map<String, String> _errors = {};
  SimpleForm(this.fieldControls, {this.formValidators, this.fieldGroups = const {}});

  // ignore: slash_for_doc_comments
  /**
   * ------------------------------------------------
   * GETTERS / SETTERS
   * ------------------------------------------------
   */
  //

  Map<String, dynamic> get data => (dataAsync is! Future)
      ? dataAsync as Map<String, dynamic>
      : throw ("it contains future, use dataAsync instead");

  //get synced data or async data if future exists
  FutureOr<Map<String, dynamic>> get dataAsync {
    List<String> fieldKeys = fieldControls.keys.toList();
    Map<String, dynamic> returnData = {};
    bool hasAsyncValue = false;

    for (final key in fieldKeys) {
      final control = fieldControls[key];
      FutureOr<dynamic> dataValue;

      if (control != null) {
        dataValue = control.data;
        if (!hasAsyncValue && dataValue is Future) hasAsyncValue = true;

        if (control.includeIfNull && dataValue == null || dataValue != null) {
          returnData.putIfAbsent(key, () => dataValue);
        }
      }
    }

    if (!hasAsyncValue) {
      // synced data
      return returnData;
    } else {
      // is needed to return future map with converter values
      return () async {
        List<String> dataKeys = returnData.keys.toList();
        for (final key in dataKeys) {
          final control = fieldControls[key];
          returnData[key] = await returnData[key];
          if (returnData[key] == null && !control!.includeIfNull) {
            returnData.remove(key);
          }
        }
        return returnData;
      }();
    }
  }

  Map<String, String> get errors => _errors;

  void setErrors(Map<String, String> errors, {String Function(dynamic error)? reduceTo}) {
    _errors.clear();

    addErrors() {
      if (reduceTo != null) {
        for (final key in fieldControls.keys) {
          final errorText = errors.containsKey(key) ? reduceTo(errors[key]) : null;
          if (errorText == null) continue;
          _errors.putIfAbsent(key, () => errorText);
        }
      } else {
        _errors.addAll(errors);
      }
    }

    addErrors();
    if (errors.isNotEmpty) _statusController.add(ControlStatus.invalid);
  }

  setInitialValues(Map<String, dynamic> initValues) {
    for (final initKey in initValues.keys) {
      if (!fieldControls.containsKey(initKey)) continue;
      final control = fieldControls[initKey]!;
      control.initValue = initValues[initKey];
    }
  }

  // ignore: slash_for_doc_comments
  /**
   * ------------------------------------------------
   * FORM METHODS
   * ------------------------------------------------
   */
  //

  void reset() {
    fieldControls.forEach((key, control) => control.reset());
    _statusController.add(ControlStatus.valid);
  }

  bool validate([BuildContext? context]) {
    _errors.clear();
    bool valid = true;

    validateEachField() {
      fieldControls.forEach((key, control) {
        final errorText = control.validatedValue;
        if (errorText != null) {
          _errors.putIfAbsent(key, () => errorText);
          valid = false;
        }
      });
    }

    validateForm() {
      if (formValidators != null) {
        for (var validator in formValidators!(context)!) {
          final errorText = validator(this);
          if (errorText != null) {
            valid = false;
            break;
          }
        }
      }
    }

    validateEachField();
    validateForm();

    return valid;
  }
}
