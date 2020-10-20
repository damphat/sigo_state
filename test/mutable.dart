import 'package:sigo_state/src/dep/mutable.dart';

import 'package:test/test.dart';

import 'immutable.dart';

void main() {
  group('mutable', () {
    group('set1', set1Tests);
    group('setn', setnTests);
  });

  group('immutable', () => immutableTests());
}

void setnTests() {
  test('1', () {
    dynamic obj;

    obj = setn(
      obj,
      ['name', 'first'],
      'Phat',
      0,
    );

    expect(obj, {
      'name': {'first': 'Phat'}
    });

    obj = setn(
      obj,
      ['name', 'last'],
      'Dam',
      0,
    );

    expect(obj, {
      'name': {
        'first': 'Phat',
        'last': 'Dam',
      }
    });
  });
}

void set1Tests() {
  group('def(value)', () {
    test('del', () {
      dynamic obj = {'x': 1, 'y': 1};
      obj = set1(obj, 'x', null);
      expect(obj, {'y': 1});
      obj = set1(obj, 'y', null);
      expect(obj, {});
    });

    test('nothing to del (map)', () {
      dynamic obj = {'y': 1};
      obj = set1(obj, 'x', null);
      expect(obj, {'y': 1});
    });

    test('nothing to del (other)', () {
      dynamic obj = 1;
      obj = set1(obj, 'x', null);
      expect(obj, 1);
    });
  });

  group('else', () {
    test('keep, identical', () {
      dynamic obj = const {'x': 1};
      obj = set1(obj, 'x', 1);
      expect(obj, {'x': 1});
    });

    test('change', () {
      dynamic obj = {'x': 1, 'y': 1};
      obj = set1(obj, 'x', 2);
      expect(obj, {'x': 2, 'y': 1});
    });

    test('add', () {
      dynamic obj = {};
      obj = set1(obj, 'x', 1);
      expect(obj, {'x': 1});
    });

    test('new', () {
      dynamic obj = 1;
      obj = set1(obj, 'x', 1);
      expect(obj, {'x': 1});
    });
  });
}
