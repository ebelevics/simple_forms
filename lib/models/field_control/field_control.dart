import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_forms/models/field_control/abstract_field_control.dart';
import 'package:simple_forms/validators/field_validators.dart';

class FieldControl<ViewT> extends AbstractFieldControl<ViewT, ViewT> {
  FieldControl({
    ViewT? initValue,
    List<FieldValidator<ViewT>> Function(AbstractFieldControl control, BuildContext? ctx)?
        validators,
    List<Future<FormFieldValidator<ViewT>>> asyncValidators = const [],
    bool includeIfNull = false,
    FutureOr<ViewT?> Function(ViewT? val)? convertToData,
  }) : super(
          initValue: initValue,
          validators: (c, ctx) => validators != null ? [for (var v in validators(c, ctx)) v] : [],
          asyncValidators: asyncValidators,
          includeIfNull: includeIfNull,
          convertToData: convertToData ?? (val) => (val),
        );
}

class FieldDataControl<ViewT, DataT> extends AbstractFieldControl<ViewT, DataT> {
  FieldDataControl({
    ViewT? initValue,
    List<FieldValidator<ViewT>> Function(AbstractFieldControl control, BuildContext? ctx)?
        validators,
    List<Future<FormFieldValidator<ViewT>>> asyncValidators = const [],
    bool includeIfNull = false,
    required FutureOr<DataT?> Function(ViewT? val) convertToData,
  }) : super(
          initValue: initValue,
          validators: (c, ctx) => validators != null ? [for (var v in validators(c, ctx)) v] : [],
          asyncValidators: asyncValidators,
          includeIfNull: includeIfNull,
          convertToData: convertToData,
        );
}
