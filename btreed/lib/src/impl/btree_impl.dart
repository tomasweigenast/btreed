import 'dart:typed_data';

import 'package:btreed/src/btree.dart';
import 'package:btreed/src/entry.dart';
import 'package:btreed/src/impl/page_manager.dart';

final class BTreeImpl implements BTree {
  final int _order; // tree order
  final PageManager _pageManager;

  BTreeImpl(this._order, this._pageManager);

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  void close() {
    // TODO: implement close
  }

  @override
  void delete(Uint8List key) {
    // TODO: implement delete
  }

  @override
  NodeEntry? get(Uint8List key) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  void insert(Uint8List key, Uint8List value) {
    // TODO: implement insert
  }

  @override
  void remove(Uint8List key, Uint8List value) {
    // TODO: implement remove
  }
}
