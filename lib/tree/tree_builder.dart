import '../mixins/calculate_child_nodes.dart';
import '../mixins/chars.dart';
import '../mixins/string_utils.dart';
import '../node/plus_tree_node.dart';
import '../node/root_tree_node.dart';

class TreeBuilder {
  RootTreeNode rootTreeNode;
  String sign = Chars.plus;
  bool division = false;
  String tempToken = '';
  List<String> positiveTokens = [];
  List<String> negativeTokens = [];
  List<String> multiplyTokens = [];
  List<String> divisionTokens = [];
  List<List<String>> plusMultiplyExpressions = [];
  List<List<String>> minusMultiplyExpressions = [];
  List<List<String>> plusMulDivExpressions = [];
  List<List<String>> plusDivMulExpressions = [];
  List<List<String>> minusMulDivExpressions = [];
  List<List<String>> minusDivMulExpressions = [];
  int openBrackets = 0;
  int closeBrackets = 0;

  TreeBuilder(this.rootTreeNode);

  void buildTreeByRoot() {
    String token = rootTreeNode.getToken();
    for (int i = 0; i < token.length; i++) {
      String ch = token[i];
      if (ch == Chars.minus) {
        if (openBrackets == closeBrackets) {
          if (divisionTokens.isNotEmpty || division) {
            conditionallyAddTempToken();
            addToMulDiv();
            division = false;
          } else {
            if (multiplyTokens.isNotEmpty) {
              multiplyTokens.add(tempToken);
            }
            flushOrAddToMultiply();
          }
          tempToken = '';
          sign = Chars.minus;
        } else {
          tempToken += ch;
        }
      } else if (ch == Chars.plus) {
        if (openBrackets == closeBrackets) {
          if (divisionTokens.isNotEmpty || division) {
            conditionallyAddTempToken();
            addToMulDiv();
            division = false;
          } else {
            if (multiplyTokens.isNotEmpty) {
              multiplyTokens.add(tempToken);
            }
            flushOrAddToMultiply();
          }
          tempToken = '';
          sign = Chars.plus;
        } else {
          tempToken += ch;
        }
      } else if (ch == Chars.lPar) {
        tempToken += ch;
        openBrackets++;
      } else if (StringUtils.isDigitOrLetter(ch)) {
        tempToken += ch;
      } else if (ch == Chars.mul) {
        if (openBrackets == closeBrackets) {
          if (division) {
            divisionTokens.add(tempToken);
          } else {
            multiplyTokens.add(tempToken);
          }
          tempToken = '';
        } else {
          tempToken += ch;
        }
        division = false;
      } else if (ch == Chars.div) {
        if (openBrackets == closeBrackets) {
          if (division) {
            divisionTokens.add(tempToken);
          } else {
            multiplyTokens.add(tempToken);
          }
          tempToken = '';
          division = true;
        } else {
          tempToken += ch;
        }
      } else if (ch == Chars.rPar) {
        closeBrackets++;
        if (openBrackets == closeBrackets) {
          if (tempToken[0] == '(') {
            tempToken = tempToken.substring(1);
          } else {
            tempToken += ch;
          }
        } else {
          tempToken += ch;
        }
      }
    }

    if (tempToken.isNotEmpty) {
      if (multiplyTokens.isEmpty && divisionTokens.isEmpty) {
        if (sign == Chars.plus) {
          positiveTokens.add(tempToken);
        } else if (sign == Chars.minus) {
          negativeTokens.add(tempToken);
        }
      }

      if (multiplyTokens.isNotEmpty) {
        if (division) {
          divisionTokens.add(tempToken);
        } else {
          multiplyTokens.add(tempToken);
        }
        if (divisionTokens.isNotEmpty) {
          addToMulDiv();
          divisionTokens.clear();
        } else {
          if (sign == Chars.plus) {
            plusMultiplyExpressions.add(List<String>.from(multiplyTokens));
          } else if (sign == Chars.minus) {
            minusMultiplyExpressions.add(List<String>.from(multiplyTokens));
          }
        }
        multiplyTokens.clear();
      }
    }

    PlusTreeNode positiveNode = PlusTreeNode();
    PlusTreeNode negativeNode = PlusTreeNode();
    positiveNode.addChildrenByToken(positiveTokens);
    negativeNode.addChildrenByToken(negativeTokens);

    if (plusMultiplyExpressions.isNotEmpty) {
      positiveNode.addMultiplyChildren(plusMultiplyExpressions);
    }
    if (minusMultiplyExpressions.isNotEmpty) {
      negativeNode.addMultiplyChildren(minusMultiplyExpressions);
    }
    if (plusMulDivExpressions.isNotEmpty && plusDivMulExpressions.isNotEmpty) {
      positiveNode.addMulDiv(plusMulDivExpressions, plusDivMulExpressions);
    }
    if (minusMulDivExpressions.isNotEmpty &&
        minusDivMulExpressions.isNotEmpty) {
      negativeNode.addMulDiv(minusMulDivExpressions, minusDivMulExpressions);
    }
    rootTreeNode.setPositive(positiveNode);
    rootTreeNode.setNegative(negativeNode);
    CalculateChildNodes.calculateChildNodes(positiveNode, negativeNode,
      (rootTreeNode) => TreeBuilder(rootTreeNode).buildTreeByRoot()
    );
  }

  void conditionallyAddTempToken() {
    if (tempToken.isNotEmpty && division) {
      divisionTokens.add(tempToken);
    }
    if (tempToken.isNotEmpty && !division) {
      multiplyTokens.add(tempToken);
    }
  }

  void flushOrAddToMultiply() {
    if (tempToken.isNotEmpty && multiplyTokens.isEmpty && divisionTokens.isEmpty) {
      flushToken();
    }
    if (multiplyTokens.isNotEmpty) {
      if (sign == Chars.plus) {
        plusMultiplyExpressions.add(List<String>.from(multiplyTokens));
      } else if (sign == Chars.minus) {
        minusMultiplyExpressions.add(List<String>.from(multiplyTokens));
      }
      multiplyTokens.clear();
    }
    if (divisionTokens.isNotEmpty) {
      if (sign == Chars.plus) {
        plusMulDivExpressions.add(List<String>.from(divisionTokens));
      } else if (sign == Chars.minus) {
        minusMulDivExpressions.add(List<String>.from(divisionTokens));
      }
      divisionTokens.clear();
    }
  }

  void flushToken() {
    if (sign == Chars.plus) {
      if (tempToken.isNotEmpty) {
        positiveTokens.add(tempToken);
      }
    } else if (sign == Chars.minus) {
      if (tempToken.isNotEmpty) {
        negativeTokens.add(tempToken);
      }
    }
  }

  void addToMulDiv() {
    if (sign == Chars.plus) {
      plusMulDivExpressions.add(List<String>.from(multiplyTokens));
      plusDivMulExpressions.add(List<String>.from(divisionTokens));
    } else if (sign == Chars.minus) {
      minusMulDivExpressions.add(List<String>.from(multiplyTokens));
      minusDivMulExpressions.add(List<String>.from(divisionTokens));
    }
    multiplyTokens.clear();
    divisionTokens.clear();
  }
}
