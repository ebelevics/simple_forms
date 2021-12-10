import 'package:flutter_test/flutter_test.dart';
import 'package:simple_forms/example/test_form.dart';

main() {
  test('Check if category json is converted correctly attached to parrent ids', () async {
    final form = TestForm();
    print(form.data);
    print(await form.data);
    print(form.validate());
    print(form.errors);
  });
}
