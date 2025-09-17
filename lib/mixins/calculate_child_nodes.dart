import '../node/plus_tree_node.dart';
import '../node/root_tree_node.dart';
import '../node/tree_node.dart';

mixin CalculateChildNodes {

  static void calculateChildNodes(PlusTreeNode positiveNode, PlusTreeNode negativeNode, Function builtTree) {
    positiveNode.getChildren().forEach((TreeNode child) {
      if (child is RootTreeNode) {
        builtTree.call(child);
      }
    });
    negativeNode.getChildren().forEach((TreeNode child) {
      if (child is RootTreeNode) {
        builtTree.call(child);
      }
    });
  }

}