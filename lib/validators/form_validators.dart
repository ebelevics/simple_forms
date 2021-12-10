import 'package:simple_forms/models/field_control/abstract_field_control.dart';
import 'package:simple_forms/models/simple_form.dart';
import 'package:simple_forms/validators/field_validators.dart';

typedef FormValidator = String? Function(SimpleForm form);

class FormValidators {
  static FormValidator match({
    required String key1,
    required String key2,
    required String errorText,
    required String markedKey,
  }) {
    return (form) {
      final hasError = form.fieldControls[key1]?.initValue !=
          form.fieldControls[key2]?.initValue;
      if (hasError) {
        form.errors.putIfAbsent(markedKey, () => errorText);
        return errorText;
      }
      return null;
    };
  }

  static FormValidator notMatch({
    required String key1,
    required String key2,
    required String errorText,
    required String markedKey,
  }) {
    return (form) {
      final hasError = form.fieldControls[key1]?.initValue ==
          form.fieldControls[key2]?.initValue;
      if (hasError) {
        form.errors.putIfAbsent(markedKey, () => errorText);
        return errorText;
      }
      return null;
    };
  }

  static FormValidator requiredIf({
    required String requiredKey,
    required bool Function(Map<String, AbstractFieldControl> fieldControls)
        ifCondition,
    required String errorText,
  }) {
    return (form) {
      final requiredValue = form.fieldControls[requiredKey]?.initValue;
      final isRequired = ifCondition(form.fieldControls);
      if (isRequired) {
        final error = FieldValidators.required(errorText)(requiredValue);
        if (error != null) {
          form.errors.putIfAbsent(requiredKey, () => errorText);
          return errorText;
        }
      }
      return null;
    };
  }

  static FormValidator requiredUnless({
    required String requiredKey,
    required bool Function(Map<String, AbstractFieldControl> fieldControls)
        unlessCondition,
    required String errorText,
  }) {
    return (form) {
      final requiredValue = form.fieldControls[requiredKey]?.initValue;
      final isRequired = !unlessCondition(form.fieldControls);
      if (isRequired) {
        final error = FieldValidators.required(errorText)(requiredValue);
        if (error != null) {
          form.errors.putIfAbsent(requiredKey, () => errorText);
          return errorText;
        }
      }
      return null;
    };
  }
}
