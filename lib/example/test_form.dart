import 'package:simple_forms/converters/simple_converters.dart';
import 'package:simple_forms/models/field_control/field_control.dart';
import 'package:simple_forms/models/simple_form.dart';
import 'package:simple_forms/validators/field_validators.dart';

class TestForm extends SimpleForm {
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String birthday = 'birthday';

  TestForm()
      : super({
          firstName: FieldControl<String>(
            initValue: "abc",
            // validators: [
            //   // FormValidators.required("REQUIRED_FIELD_ERR"),
            //   // FormValidators.regex(hasOnlyLettersREG, "NAMING_FIELD_ERR"),
            // ],
          ),
          lastName: FieldControl<String>(
            initValue: "xyz",
            validators: (control, ctx) => [
              FieldValidators.required("REQUIRED_FIELD_ERR"),
            ],
          ),
          birthday: FieldDataControl<DateTime?, String?>(
              initValue: DateTime.now(), convertToData: SimpleConverters.dateTimetoIso8601String),
        });
}
