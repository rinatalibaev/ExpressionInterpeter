import 'dart:core';

import '../../node/tree_node.dart';

class MulDivTreeNode extends TreeNode {
  List<TreeNode> mulChildren = [];
  List<TreeNode> divChildren = [];

  @override
  double calcResult(Map<String, num> map) {
    double result = 1;
    for (TreeNode child in mulChildren) {
      result *= child.calcResult(map);
    }
    for (TreeNode child in divChildren) {
      result /= child.calcResult(map);
    }
    return result;
  }

  void addMulChildren(List<TreeNode> children) => mulChildren += children;
  void addDivChildren(List<TreeNode> children) => divChildren += children;
}
