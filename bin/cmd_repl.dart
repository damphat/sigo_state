import 'package:json5/json5.dart';
import 'package:sigo_state/sigo_state.dart';
import 'repl.dart';

void main() {
  dynamic state;

  repl((src) {
    state = cmdExec(state, src);
    return json5Encode(state, space: 2);
  });
}
