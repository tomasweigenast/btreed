import 'dart:typed_data';

import 'package:btreed/src/key.dart';

abstract interface class BTree {
  void insert(Uint8List key, Uint8List value);
  Key? get(Uint8List key);
  void delete(Uint8List key);
  void remove(Uint8List key, Uint8List value);
  void clear();
  void close();
}
