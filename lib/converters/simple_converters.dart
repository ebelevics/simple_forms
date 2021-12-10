import 'dart:async';

typedef SimpleConverter<ViewT, DataT> = FutureOr<DataT?> Function(ViewT? view);

class SimpleConverters {
  static int? boolToInt(bool? val) => (val != null)
      ? val
          ? 1
          : 0
      : null;

  static String? enumToString(Enum? enm) => (enm != null) ? enm.name : null;

  static String? dateTimetoIso8601String(DateTime? val) =>
      (val != null) ? val.toIso8601String() : null;
}
