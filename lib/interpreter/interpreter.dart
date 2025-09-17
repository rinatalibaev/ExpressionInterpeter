import 'package:expression_interpreter/tree/tree_builder.dart';

import '../node/root_tree_node.dart';

class Interpreter {

    late final RootTreeNode rootNode;

    Interpreter(String exp) {
        rootNode = RootTreeNode(exp);
        TreeBuilder treeBuilder = TreeBuilder(rootNode);
        treeBuilder.buildTreeByRoot();
    }

    double calculate(Map<String, num> map) {
        return rootNode.calcResult(map);
    }


}