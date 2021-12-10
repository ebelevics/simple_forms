abstract class AbstractFieldValidator<T> {
  String? validate(T? value);
}

class FieldValidatorHelper<T> extends AbstractFieldValidator<T> {
  final FieldValidator<T?> validator;
  FieldValidatorHelper(this.validator);

  @override
  String? validate(T? value) => validator(value);
}

typedef FieldValidator<T> = String? Function(T? value);

class FieldValidators {
  static FieldValidator<num> min(num min, String? errorText, {bool inclusive = true}) {
    return (value) {
      if (value == null) return null;
      return (inclusive ? value < min : value <= min) ? errorText : null;
    };
  }

  static FieldValidator<num> max(num max, String? errorText, {bool inclusive = true}) {
    return (value) {
      if (value == null) return null;
      return (inclusive ? value > max : value >= max) ? errorText : null;
    };
  }

  static FieldValidator<String?> minLength(
    int minLength,
    String errorText, {
    bool allowEmpty = false,
  }) {
    assert(minLength > 0);
    return (valueCandidate) {
      final valueLength = valueCandidate?.length ?? 0;
      return valueLength < minLength && (!allowEmpty || valueLength > 0) ? errorText : null;
    };
  }

  static FieldValidator<String?> maxLength(int maxLength, String errorText) {
    return (value) {
      final valueLength = value?.length ?? 0;
      return valueLength > maxLength ? errorText : null;
    };
  }

  static FieldValidator<String?> regex(String pattern, String errorText) =>
      (value) => true == value?.isNotEmpty && !RegExp(pattern).hasMatch(value!) ? errorText : null;

  static FieldValidator<T> required<T>(String errorText) {
    return (value) {
      if (value == null ||
          (value is bool && value == false) ||
          (value is String && value.isEmpty) ||
          (value is Iterable && value.isEmpty) ||
          (value is Map && value.isEmpty)) {
        return errorText;
      }
      return null;
    };
  }
}
