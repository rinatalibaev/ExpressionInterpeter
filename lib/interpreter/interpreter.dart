import '../node/plus_tree_node.dart';
import '../node/root_tree_node.dart';
import '../node/tree_node.dart';

class Interpreter {

    static const String plus = '+';
    static const String minus = '-';
    static const String lPar = '(';
    static const String rPar = ')';
    static const String mul = '*';
    static const String div = '/';
    late final RootTreeNode rootNode;

    Interpreter(String exp) {
        rootNode = RootTreeNode(exp);
        buildTreeByRoot(rootNode);
    }

    double calculate(Map<String, double> map) {
        return rootNode.calcResult(map);
    }

    static void buildTreeByRoot(RootTreeNode rootTreeNode)  {
        String token = rootTreeNode.getToken();
        String sign = plus;
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

        for (int i = 0; i < token.length; i++) {
            String ch = token[i];
            if (ch == minus) {
                if (openBrackets == closeBrackets) {
                    if (divisionTokens.isNotEmpty || division) {
                        conditionallyAddTempToken(tempToken, division, divisionTokens, multiplyTokens);
                        addToMulDiv(sign, multiplyTokens, divisionTokens, plusMulDivExpressions, minusMulDivExpressions, plusDivMulExpressions, minusDivMulExpressions);
                        division = false;
                    } else {
                        if (multiplyTokens.isNotEmpty) {
                            multiplyTokens.add(tempToken);
                        }
                        flushOrAddToMultiply(tempToken, sign, positiveTokens, negativeTokens, multiplyTokens, divisionTokens,
                                plusMultiplyExpressions, minusMultiplyExpressions, plusMulDivExpressions, minusMulDivExpressions);
                    }
                    tempToken = '';
                    sign = minus;
                } else {
                    tempToken += ch;
                }
            } else if (ch == plus) {
                if (openBrackets == closeBrackets) {
                    if (divisionTokens.isNotEmpty || division) {
                        conditionallyAddTempToken(tempToken, division, divisionTokens, multiplyTokens);
                        addToMulDiv(sign, multiplyTokens, divisionTokens, plusMulDivExpressions, minusMulDivExpressions, plusDivMulExpressions, minusDivMulExpressions);
                        division = false;
                    } else {
                        if (multiplyTokens.isNotEmpty) {
                            multiplyTokens.add(tempToken);
                        }
                        flushOrAddToMultiply(tempToken, sign, positiveTokens, negativeTokens, multiplyTokens, divisionTokens,
                                plusMultiplyExpressions, minusMultiplyExpressions, plusMulDivExpressions, minusMulDivExpressions);
                    }
                    tempToken = '';
                    sign = plus;
                } else {
                    tempToken += ch;
                }
            } else if (ch == lPar) {
                tempToken += ch;
                openBrackets++;
            } else if (charIsDigit(ch)) {
                tempToken += ch;
            } else if (ch == mul) {
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
            } else if (ch == div) {
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
            } else if (ch == rPar) {
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
                if (sign == plus) {
                    positiveTokens.add(tempToken);
                }
                else if (sign == minus) {
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
                    addToMulDiv(sign, multiplyTokens, divisionTokens, plusMulDivExpressions, minusMulDivExpressions, plusDivMulExpressions, minusDivMulExpressions);
                    divisionTokens.clear();
                } else {
                    if (sign == plus) {
                        plusMultiplyExpressions.add(List<String>.from(multiplyTokens));
                    }
                    else if (sign == minus) {
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
        if (minusMulDivExpressions.isNotEmpty && minusDivMulExpressions.isNotEmpty) {
            negativeNode.addMulDiv(minusMulDivExpressions, minusDivMulExpressions);
        }
        rootTreeNode.setPositive(positiveNode);
        rootTreeNode.setNegative(negativeNode);
        calculateChildNodes(positiveNode, negativeNode);
    }

    static void conditionallyAddTempToken(String tempToken, bool division, List<String> divisionTokens, List<String> multiplyTokens) {
        if (tempToken.isNotEmpty && division) {
            divisionTokens.add(tempToken);
        }
        if (tempToken.isNotEmpty && !division) {
            multiplyTokens.add(tempToken);
        }
    }

    static void flushOrAddToMultiply(String tempToken, String sign, List<String> positiveTokens,
                                             List<String> negativeTokens, List<String> multiplyTokens, List<String> divisionTokens,
                                             List<List<String>> plusMultiplyExpressions, List<List<String>> minusMultiplyExpressions,
                                             List<List<String>> plusDivisionExpressions, List<List<String>> minusDivisionExpressions) {
        if (tempToken.isNotEmpty && multiplyTokens.isEmpty && divisionTokens.isEmpty) {
            flushToken(sign, tempToken, positiveTokens, negativeTokens);
        }
        if (multiplyTokens.isNotEmpty) {
            if (sign == plus) {
                plusMultiplyExpressions.add(List<String>.from(multiplyTokens));
            } else if (sign == minus) {
                minusMultiplyExpressions.add(List<String>.from(multiplyTokens));
            }
            multiplyTokens.clear();
        }
        if (divisionTokens.isNotEmpty) {
            if (sign == plus) {
                plusDivisionExpressions.add(List<String>.from(divisionTokens));
            } else if (sign == minus) {
                minusDivisionExpressions.add(List<String>.from(divisionTokens));
            }
            divisionTokens.clear();
        }
    }

    static void addToMulDiv(String sign, List<String> multiplyTokens, List<String> divisionTokens,
                                    List<List<String>> plusMulDivExpressions, List<List<String>> minusMulDivExpressions,
                                    List<List<String>> plusDivMulExpressions, List<List<String>> minusDivMulExpressions) {
        if (sign == plus) {
            plusMulDivExpressions.add(List<String>.from(multiplyTokens));
            plusDivMulExpressions.add(List<String>.from(divisionTokens));
        } else if (sign == minus) {
            minusMulDivExpressions.add(List<String>.from(multiplyTokens));
            minusDivMulExpressions.add(List<String>.from(divisionTokens));
        }
        multiplyTokens.clear();
        divisionTokens.clear();
    }

    static void calculateChildNodes(PlusTreeNode positiveNode, PlusTreeNode negativeNode) {
        positiveNode.getChildren().forEach((TreeNode child) {
            if (child is RootTreeNode) {
                buildTreeByRoot(child);
            }
        });
        negativeNode.getChildren().forEach((TreeNode child) {
            if (child is RootTreeNode) {
                buildTreeByRoot(child);
            }
        });
    }

    static bool charIsDigit(String ch) {
        return ch.codeUnitAt(0) >= '0'.codeUnitAt(0) && ch.codeUnitAt(0) <= '9'.codeUnitAt(0)
            || ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'z'.codeUnitAt(0);
    }

    static void flushToken(String sign, String tempToken, List<String> positiveTokens, List<String> negativeTokens) {
        if (sign == plus) {
            if (tempToken.isNotEmpty) {
                positiveTokens.add(tempToken);
            }
        } else if (sign == minus) {
            if (tempToken.isNotEmpty) {
                negativeTokens.add(tempToken);
            }
        }
    }
}