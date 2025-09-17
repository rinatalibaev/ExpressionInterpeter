import 'package:expression_interpreter/interpreter/interpreter.dart';

void main() {
  String exp = '-40/(x-92)*2+5*(7-z)*y';
  Interpreter expressionInterpreter = Interpreter(exp);
  Map<String, double> map = {};
  map['x'] = 100.0;
  map['y'] = 12.0;
  map['z'] = 4.0;
  double result = expressionInterpreter.calculate(map);
  print('Result: $result');
}