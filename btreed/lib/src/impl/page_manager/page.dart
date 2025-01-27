import 'dart:typed_data';

final class Page {
  final int id;
  final Uint8List data;
  bool dirty;

  Page({required this.id, required this.data}) : dirty = false;
}
