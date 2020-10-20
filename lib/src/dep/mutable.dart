bool def(dynamic value) => value == null;

dynamic get1(dynamic obj, String key) {
  if (obj is Map) return obj[key];
  return null;
}

dynamic set1(dynamic obj, String key, dynamic value) {
  if (def(value)) {
    if (obj is Map) {
      if (obj.containsKey(key)) {
        obj.remove(key);
        return obj; // del: {key:old}.key = def
      } else {
        return obj; // nothing to deldel: {}.key = def
      }
    } else {
      return obj; // nothing: 1.key = def
    }
  } else {
    if (obj is Map) {
      if (obj.containsKey(key)) {
        var old = obj[key];
        if (identical(old, value)) {
          return obj; // nothing: {key: old}.key = old;
        } else {
          obj[key] = value;
          return obj; // change: {key: old}.key = value
        }
      } else {
        obj[key] = value;
        return obj; // add: {x: v}.key = value;
      }
    } else {
      obj = {key: value};
      return obj; // new: 1.key = value;
    }
  }
}

// TODO index = 0
dynamic setn(dynamic obj, List<String> keys, dynamic value, int index) {
  final len = keys.length;
  // TODO do we need '()'?
  if (index < 0 || index >= len) throw 'index is out of range';

  var key = keys[index];

  if (len - index == 1) {
    return set1(obj, keys[index], value);
  }

  return set1(
    obj,
    key,
    setn(
      get1(obj, key),
      keys,
      value,
      index + 1,
    ),
  );
}
