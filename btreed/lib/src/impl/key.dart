import 'dart:typed_data';

/// [Key] represents a BTree key with its values
final class Key {
  /// The actual's key value.
  final Uint8List key;

  /// The list of values contained in this key
  final List<Uint8List> values;

  const Key({required this.key, required this.values});
}
