import 'package:sigo_state/sigo_state.dart';
import 'package:test/test.dart';

void main() {
  group('cmd - get', () {
    test('obj', () {
      dynamic s = {
        'n': {'a': 1}
      };

      expect(cmdExec(s, ''), s);
      expect(
        cmdExec(s, 'n'),
        s['n'],
      );
      expect(
        cmdExec(s, 'n.a'),
        s['n']['a'],
      );
      expect(
        cmdExec(s, 'n.b'),
        isNull,
      );
      expect(
        cmdExec(s, 'n.b.c.d'),
        isNull,
      );
    });

    test('num', () {
      expect(cmdExec(1, 'x'), isNull);
    });
  });

  group('cmd - set', () {
    test('new:={x:1}', () {
      dynamic s;
      dynamic s1 = cmdExec(s, '={x:1}');
      expect(s1, {'x': 1});
    });

    test('set', () {
      dynamic s;
      dynamic s1 = cmdExec(s, 'x = 1');
      dynamic s2 = cmdExec(s1, 'y = 1');
      expect(s1, {'x': 1});
      expect(s2, {'x': 1, 'y': 1});

      var s3 = cmdExec(s2, '=1');
      expect(s3, 1);
    });

    test('set - keep', () {
      dynamic s = {'x': 1.0};
      dynamic s1 = cmdExec(s, 'x = 1');
      dynamic s2 = cmdExec(s, 'y = null');
      expect(s1, same(s));
      expect(s2, same(s1));
    });

    test('set - change', () {
      dynamic s = {'x': 1};
      dynamic s1 = cmdExec(s, 'x = 2');
      expect(s, {'x': 1});
      expect(s1, {'x': 2});
    });

    test('set - add', () {
      dynamic s = {'x': 1.0};
      dynamic s1 = cmdExec(s, 'a.b = 1');
      expect(s, {'x': 1.0});
      expect(s1, {
        'x': 1.0,
        'a': {'b': 1.0}
      });
    });

    test('set - rmv', () {
      dynamic s = {
        'x': 1.0,
        'a': {'b': 1.0}
      };
      dynamic s1 = cmdExec(s, 'a.b = null');
      dynamic s2 = cmdExec(s1, 'a = null');
      dynamic s3 = cmdExec(s2, 'x = null');

      expect(s, {
        'x': 1.0,
        'a': {'b': 1.0}
      });
      expect(s1, {'x': 1.0, 'a': {}});
      expect(s2, {'x': 1.0});
      expect(s3, {});
    });
  });
}
