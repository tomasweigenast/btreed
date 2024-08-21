import 'package:btreed/src/impl/key.dart';

/// A node inside a BTree
final class Node {
  /// The page number of the node
  final int pageNumber;

  /// The list of keys inside the node
  final List<Key> keys;

  /// The list of children of this node
  final List<int> children;

  /// A flag that indicates if this node is a leaf node.
  final bool isLeaf;

  Node({required this.pageNumber, required this.keys, required this.children, required this.isLeaf});
}
