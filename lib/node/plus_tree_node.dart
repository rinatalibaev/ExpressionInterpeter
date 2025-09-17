import 'leaf_node.dart';
import 'mul_div_tree_node.dart';
import 'multiply_tree_node.dart';
import '../../node/root_tree_node.dart';
import '../../node/tree_node.dart';
import '../interpreter/interpreter.dart';

class PlusTreeNode extends TreeNode {
  final List<TreeNode> children = [];

  List<TreeNode> getChildren() {
    return children;
  }

  void addChildrenByToken(List<String> tokens) {
    for (String token in tokens) {
      isLeaf(token);
      if (isLeaf(token)) {
        LeafNode leafNode = LeafNode();
        leafNode.setToken(token);
        children.add(leafNode);
      } else {
        RootTreeNode rootTreeNode = RootTreeNode(token);
        children.add(rootTreeNode);
      }
    }
  }

  void addMultiplyChildren(List<List<String>> multiplyExpressions) {
    for (List<String> tokens in multiplyExpressions) {
      List<LeafNode> leafChildren = [];
      List<TreeNode> expressionChildren = [];
      MultiplyTreeNode multiplyTreeNode = MultiplyTreeNode();

      addNodes(tokens, leafChildren, expressionChildren);

      multiplyTreeNode.setLeafChildren(leafChildren);
      multiplyTreeNode.setExpressionChildren(expressionChildren);
      children.add(multiplyTreeNode);
    }
  }

  void addMulDiv(List<List<String>> plusMulDivExpressions, List<List<String>> plusDivMulExpressions) {
    MulDivTreeNode mulDivTreeNode = MulDivTreeNode();
    for (List<String> tokens in plusMulDivExpressions) {
      List<LeafNode> mulLeafChildren = [];
      List<TreeNode> mulExpressionChildren = [];

      addNodes(tokens, mulLeafChildren, mulExpressionChildren);

      mulDivTreeNode.setMulLeafChildren(mulLeafChildren);
      mulDivTreeNode.setMulExpressionChildren(mulExpressionChildren);
    }

    for (List<String> tokens in plusDivMulExpressions) {
      List<LeafNode> divLeafChildren = [];
      List<TreeNode> divExpressionChildren = [];

      addNodes(tokens, divLeafChildren, divExpressionChildren);

      mulDivTreeNode.setDivLeafChildren(divLeafChildren);
      mulDivTreeNode.setDivExpressionChildren(divExpressionChildren);
    }
    children.add(mulDivTreeNode);
  }

  void addNodes(List<String> tokens, List<LeafNode> leafChildren, List<TreeNode> expressionChildren) {
    for (String token in tokens) {
      if (isLeaf(token)) {
        LeafNode leafNode = LeafNode();
        leafNode.setToken(token);
        leafChildren.add(leafNode);
      } else {
        PlusTreeNode positiveNode = PlusTreeNode();
        PlusTreeNode negativeNode = PlusTreeNode();
        positiveNode.addChildrenByToken([token]);
        negativeNode.addChildrenByToken([]);
        expressionChildren.add(positiveNode);
        Interpreter.calculateChildNodes(positiveNode, negativeNode);
      }
    }
  }

  @override
  double calcResult(Map<String, num> map) {
    double result = 0;
    for (TreeNode child in children) {
      result += child.calcResult(map);
    }
    return result;
  }

  bool charIsDigit(String ch) {
    return ch.codeUnitAt(0) >= '0'.codeUnitAt(0) && ch.codeUnitAt(0) <= '9'.codeUnitAt(0);
  }

  bool charIsLetter(String ch) {
    return ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'z'.codeUnitAt(0);
  }

  bool isLeaf(String token) {
    bool leaf = true;
    for (int i = 0; i < token.length; i++) {
      bool digit = charIsDigit(token[i]);
      bool letter = charIsLetter(token[i]);
      if (i == 0) {
        if (token[i] != '-' && !(digit || letter)) {
          leaf = false;
        }
      } else {
        if (!digit && !letter) {
          leaf = false;
        }
      }
    }
    return leaf;
  }
}