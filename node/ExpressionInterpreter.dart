import 'PlusTreeNode.dart';
import 'RootTreeNode.dart';
import 'TreeNode.dart';

class ExpressionInterpreter {

    static const String PLUS = '+';
    static const String MINUS = '-';
    static const String L_PAR = '(';
    static const String R_PAR = ')';
    static const String MUL = '*';
    static const String DIV = '/';
    late final RootTreeNode rootNode;

    ExpressionInterpreter(String exp) {
        this.rootNode = new RootTreeNode(exp);
        buildTreeByRoot(rootNode);
    }

    double calculate(Map<String, double> map) {
        return rootNode.calcResult(map);
    }

    static void buildTreeByRoot(RootTreeNode rootTreeNode)  {
        String token = rootTreeNode.getToken();
        List<String> positiveTokens = [];
        List<String> negativeTokens = [];
        String sign = PLUS;
        bool division = false;
        String tempToken = "";
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
            if (ch == MINUS) {
                if (openBrackets == closeBrackets) {
                    if (!divisionTokens.isEmpty || division) {
                        conditionallyAddTempToken(tempToken, division, divisionTokens, multiplyTokens);
                        addToMulDiv(sign, multiplyTokens, divisionTokens, plusMulDivExpressions, minusMulDivExpressions, plusDivMulExpressions, minusDivMulExpressions);
                        division = false;
                    } else {
                        if (!multiplyTokens.isEmpty) {
                            multiplyTokens.add(tempToken);
                        }
                        flushOrAddToMultiply(tempToken, sign, positiveTokens, negativeTokens, multiplyTokens, divisionTokens,
                                plusMultiplyExpressions, minusMultiplyExpressions, plusMulDivExpressions, minusMulDivExpressions);
                    }
                    tempToken = "";
                    sign = MINUS;
                } else {
                    tempToken += ch;
                }
            } else if (ch == PLUS) {
                if (openBrackets == closeBrackets) {
                    if (!divisionTokens.isEmpty || division) {
                        conditionallyAddTempToken(tempToken, division, divisionTokens, multiplyTokens);
                        addToMulDiv(sign, multiplyTokens, divisionTokens, plusMulDivExpressions, minusMulDivExpressions, plusDivMulExpressions, minusDivMulExpressions);
                        division = false;
                    } else {
                        if (!multiplyTokens.isEmpty) {
                            multiplyTokens.add(tempToken);
                        }
                        flushOrAddToMultiply(tempToken, sign, positiveTokens, negativeTokens, multiplyTokens, divisionTokens,
                                plusMultiplyExpressions, minusMultiplyExpressions, plusMulDivExpressions, minusMulDivExpressions);
                    }
                    tempToken = "";
                    sign = PLUS;
                } else {
                    tempToken += ch;
                }
            } else if (ch == L_PAR) {
                tempToken += ch;
                openBrackets++;
            } else if (charIsDigit(ch)) {
                tempToken += ch;
            } else if (ch == MUL) {
                if (openBrackets == closeBrackets) {
                    if (division) {
                        divisionTokens.add(tempToken);
                    } else {
                        multiplyTokens.add(tempToken);
                    }
                    tempToken = "";
                } else {
                    tempToken += ch;
                }
                division = false;
            } else if (ch == DIV) {
                if (openBrackets == closeBrackets) {
                    if (division) {
                        divisionTokens.add(tempToken);
                    } else {
                        multiplyTokens.add(tempToken);
                    }
                    tempToken = "";
                    division = true;
                } else {
                    tempToken += ch;
                }
            } else if (ch == R_PAR) {
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
        if (!tempToken.isEmpty) {
            if (multiplyTokens.isEmpty && divisionTokens.isEmpty) {
                if (sign == PLUS) {
                    positiveTokens.add(tempToken);
                }
                else if (sign == MINUS) {
                    negativeTokens.add(tempToken);
                }
            }

            if (!multiplyTokens.isEmpty) {
                if (division) {
                    divisionTokens.add(tempToken);
                } else {
                    multiplyTokens.add(tempToken);
                }
                if (!divisionTokens.isEmpty) {
                    addToMulDiv(sign, multiplyTokens, divisionTokens, plusMulDivExpressions, minusMulDivExpressions, plusDivMulExpressions, minusDivMulExpressions);
                    divisionTokens.clear();
                } else {
                    if (sign == PLUS) {
                        plusMultiplyExpressions.add(new List<String>.from(multiplyTokens));
                    }
                    else if (sign == MINUS) {
                        minusMultiplyExpressions.add(new List<String>.from(multiplyTokens));
                    }
                }
                multiplyTokens.clear();
            }
        }

        PlusTreeNode positiveNode = new PlusTreeNode();
        PlusTreeNode negativeNode = new PlusTreeNode();
        positiveNode.addChildrenByToken(positiveTokens);
        negativeNode.addChildrenByToken(negativeTokens);

        if (!plusMultiplyExpressions.isEmpty) {
            positiveNode.addMultiplyChildren(plusMultiplyExpressions);
        }
        if (!minusMultiplyExpressions.isEmpty) {
            negativeNode.addMultiplyChildren(minusMultiplyExpressions);
        }
        if (!plusMulDivExpressions.isEmpty && !plusDivMulExpressions.isEmpty) {
            positiveNode.addMulDiv(plusMulDivExpressions, plusDivMulExpressions);
        }
        if (!minusMulDivExpressions.isEmpty && !minusDivMulExpressions.isEmpty) {
            negativeNode.addMulDiv(minusMulDivExpressions, minusDivMulExpressions);
        }
        rootTreeNode.setPositive(positiveNode);
        rootTreeNode.setNegative(negativeNode);
        calculateChildNodes(positiveNode, negativeNode);
    }

    static void conditionallyAddTempToken(String tempToken, bool division, List<String> divisionTokens, List<String> multiplyTokens) {
        if (!tempToken.isEmpty && division) {
            divisionTokens.add(tempToken);
        }
        if (!tempToken.isEmpty && !division) {
            multiplyTokens.add(tempToken);
        }
    }

    static void flushOrAddToMultiply(String tempToken, String sign, List<String> positiveTokens,
                                             List<String> negativeTokens, List<String> multiplyTokens, List<String> divisionTokens,
                                             List<List<String>> plusMultiplyExpressions, List<List<String>> minusMultiplyExpressions,
                                             List<List<String>> plusDivisionExpressions, List<List<String>> minusDivisionExpressions) {
        if (!tempToken.isEmpty && multiplyTokens.isEmpty && divisionTokens.isEmpty) {
            flushToken(sign, tempToken, positiveTokens, negativeTokens);
        }
        if (!multiplyTokens.isEmpty) {
            if (sign == PLUS) {
                plusMultiplyExpressions.add(new List<String>.from(multiplyTokens));
            } else if (sign == MINUS) {
                minusMultiplyExpressions.add(new List<String>.from(multiplyTokens));
            }
            multiplyTokens.clear();
        }
        if (!divisionTokens.isEmpty) {
            if (sign == PLUS) {
                plusDivisionExpressions.add(new List<String>.from(divisionTokens));
            } else if (sign == MINUS) {
                minusDivisionExpressions.add(new List<String>.from(divisionTokens));
            }
            divisionTokens.clear();
        }
    }

    static void addToMulDiv(String sign, List<String> multiplyTokens, List<String> divisionTokens,
                                    List<List<String>> plusMulDivExpressions, List<List<String>> minusMulDivExpressions,
                                    List<List<String>> plusDivMulExpressions, List<List<String>> minusDivMulExpressions) {
        if (sign == PLUS) {
            plusMulDivExpressions.add(new List<String>.from(multiplyTokens));
            plusDivMulExpressions.add(new List<String>.from(divisionTokens));
        } else if (sign == MINUS) {
            minusMulDivExpressions.add(new List<String>.from(multiplyTokens));
            minusDivMulExpressions.add(new List<String>.from(divisionTokens));
        }
        multiplyTokens.clear();
        divisionTokens.clear();
    }

    static void calculateChildNodes(PlusTreeNode positiveNode, PlusTreeNode negativeNode) {
        positiveNode.getChildren().forEach((TreeNode child) {
            if (child is RootTreeNode) {
                buildTreeByRoot(child);
            };
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
        if (sign == PLUS) {
            if (!tempToken.isEmpty) {
                positiveTokens.add(tempToken);
            }
        } else if (sign == MINUS) {
            if (!tempToken.isEmpty) {
                negativeTokens.add(tempToken);
            }
        }
    }
}