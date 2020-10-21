import 'package:sigo_state/src/immutable.dart';
import 'package:test/test.dart';

void immutableTests() {
  test('simple', () {
    dynamic obj = false;
    obj = setn(obj, ['name'], 'phat', true, 0);
    expect(obj, {'name': 'phat'});

    var des = setn(obj, ['name'], 'phat', true, 0);
    expect(des, {'name': 'phat'});
    expect(obj, same(des));
  });
}
