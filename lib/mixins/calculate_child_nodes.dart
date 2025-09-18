import '../node/plus_tree_node.dart';
import '../node/root_tree_node.dart';

mixin CalculateChildNodes {

  static void calculateChildNodes(PlusTreeNode positiveNode, PlusTreeNode negativeNode, Function builtTree) {
    positiveNode.getChildren()
        .whereType<RootTreeNode>()
        .forEach((child) => builtTree.call(child));

    negativeNode.getChildren()
        .whereType<RootTreeNode>()
        .forEach((child) => builtTree.call(child));
  }

}