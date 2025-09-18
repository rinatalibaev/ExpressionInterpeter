import 'package:expression_interpreter/tree/tree_builder.dart';

import '../node/root_tree_node.dart';

class Interpreter {
  late final RootTreeNode rootNode;

  Interpreter(String exp) {
    rootNode = RootTreeNode(exp);
    TreeBuilder(rootNode).buildTree();
  }

  double calculate(Map<String, num> map) => rootNode.calcResult(map);
}
