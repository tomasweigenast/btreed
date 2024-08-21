import 'dart:typed_data';

import 'package:btreed/src/entry.dart';
import 'package:btreed/src/impl/btree_impl.dart';
import 'package:btreed/src/impl/page_manager.dart';

abstract interface class BTree {
  factory BTree({required String filePath, int order = 3}) => BTreeImpl(
        order,
        PageManager(filePath: filePath),
      );

  factory BTree.openWith({required String filePath, required int pageSize, required int headerSize, int order = 3}) =>
      BTreeImpl(order, PageManager(filePath: filePath, headerSize: headerSize, pageSize: pageSize));

  void insert(Uint8List key, Uint8List value);
  NodeEntry? get(Uint8List key);
  void delete(Uint8List key);
  void remove(Uint8List key, Uint8List value);
  void clear();
  void close();
}
