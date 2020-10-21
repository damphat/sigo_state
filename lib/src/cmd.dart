import 'package:json5/json5.dart';
import 'package:sigo_state/src/immutable.dart';

dynamic jsony(String src) {
  if (src == null) return null;
  if (src.isEmpty) return null;

  try {
    return json5Decode(src);
  } catch (e) {
    if (RegExp(r'[a-zA-Z0-9_]').hasMatch(src)) {
      return src;
    }
    rethrow;
  }
}

class Cmd {
  String type;
  String path;
  dynamic value;
  List<String> keys;
}

Cmd cmdParse(String cmdText) {
  var ret = Cmd();

  if (cmdText.contains('=')) {
    ret.type = 'set';
    var pv = cmdText.split('=');
    ret.path = pv[0].trim();
    ret.value = pv[1].trim();
  } else {
    ret.type = 'get';
    ret.path = cmdText;
  }
  if (ret.path == null || ret.path.isEmpty) {
    ret.keys = [];
  } else {
    ret.keys = ret.path.split('.');
  }

  ret.value = jsony(ret.value);
  return ret;
}

dynamic cmdExec(dynamic obj, String cmdText) {
  var cmd = cmdParse(cmdText);
  if (cmd.type == 'get') {
    return getn(obj, cmd.keys);
  }

  if (cmd.type == 'set') {
    return setn(obj, cmd.keys, cmd.value, true, 0);
  }
}

void cmdFlag(String newFlag) {
  flag = newFlag;
}
