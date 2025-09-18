import 'dart:core';

import '../../node/tree_node.dart';

class LeafNode extends TreeNode {
  String? token;

  @override
  double calcResult(Map<String, num> map) => parseToDouble(map);

  void setToken(String token) {
    this.token = token;
  }

  double parseToDouble(Map<String, num> map) {
    'a'.codeUnitAt(0) >= 'b'.codeUnitAt(0);
    if (token?.length == 1 && token!.codeUnitAt(0) >= 'a'.codeUnitAt(0) && token!.codeUnitAt(0) <= 'z'.codeUnitAt(0)) {
      return map[token]!.toDouble();
    }
    return double.tryParse(token!)!;
  }

}
