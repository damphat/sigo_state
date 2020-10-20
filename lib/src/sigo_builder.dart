class StateBuilder {
  dynamic _state;
  dynamic get state => _state;
  StateBuilder(this._state);
  

  static const String flag = '_';
  static bool _def(dynamic value) => value == null;

  static dynamic _get1(dynamic obj, String key) {
    if (obj is Map<String, dynamic>) return obj[key];
    return null;
  }

  static Map<String, dynamic> _merge1(
      Map<String, dynamic> des, Map<String, dynamic> src) {
    for (var key in src.keys) {
      if (key != flag) des[key] = src[key];
    }

    return des;
  }

  static int _id = 0;
  static Map<String, dynamic> _new1() {
    return <String, dynamic>{flag: _id++};
  }

  static Map<String, dynamic> _new2(String key, dynamic value) {
    var ret = _new1();
    ret[key] = value;
    return ret;
  }

  static Map<String, dynamic> _remove1(
      Map<String, dynamic> obj, String key, bool immutable) {
    assert(obj.containsKey(key));

    if (immutable) {
      var des = _merge1(_new1(), obj);
      des.remove(key);

      return des; // immutable remove
    } else {
      obj.remove(key);

      return obj; // mutable remove
    }
  }

  static Map<String, dynamic> _change1(
      Map<String, dynamic> obj, String key, dynamic value, bool immutable) {
    assert(obj.containsKey(key));

    if (immutable) {
      var des = _merge1(_new1(), obj);
      des[key] = value;

      return des; // immutable change
    } else {
      obj[key] = value;

      return obj; // mutable change
    }
  }

  static Map<String, dynamic> _add1(
      Map<String, dynamic> obj, String key, dynamic value, bool immutable) {
    if (immutable) {
      var des = _merge1(_new1(), obj);
      des[key] = value;

      return des;
    } else {
      obj[key] = value;

      return obj;
    }
  }

  static dynamic _set1(dynamic obj, String key, dynamic value, bool immutable) {
    if (_def(value)) {
      if (obj is Map<String, dynamic>) {
        if (obj.containsKey(key)) {
          return _remove1(obj, key, immutable); // remove
        } else {
          return obj; // nothing to deldel: {}.key = def
        }
      } else {
        return obj; // nothing: 1.key = def
      }
    } else {
      if (obj is Map<String, dynamic>) {
        if (obj.containsKey(key)) {
          var old = obj[key];
          if (identical(old, value)) {
            return obj; // nothing: {key: old}.key = old;
          } else {
            return _change1(obj, key, value, immutable);
          }
        } else {
          return _add1(obj, key, value, immutable);
        }
      } else {
        obj = _new2(key, value);
        return obj; // new: 1.key = value;
      }
    }
  }

  static dynamic _getn(dynamic obj, List<String> keys) {
    if (keys == null) return obj;

    for (var key in keys) {
      if (obj == null) return null;
      obj = _get1(obj, key);
    }
    return obj;
  }

  static dynamic _setn(dynamic obj, List<String> keys, dynamic value,
      bool immutable, int index) {
    final len = keys.length;
    index ??= 0;
    if (index < 0 || index > len) throw 'index is out of range';

    switch (len - index) {
      case 0:
        return value;
      case 1:
        return _set1(obj, keys[index], value, immutable);
      default:
        var key = keys[index];
        return _set1(
          obj,
          key,
          _setn(
            _get1(obj, key),
            keys,
            value,
            immutable,
            index + 1,
          ),
          immutable,
        );
    }
  }


}
