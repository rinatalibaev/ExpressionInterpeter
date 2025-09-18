import 'package:expression_interpreter/interpreter/interpreter.dart';
import 'package:talker/talker.dart';

final talker = Talker();

void main() {
  final talker = Talker();
  const String exp = '-40/(x-92)*2+5*(7-z)*y';
  Interpreter expressionInterpreter = Interpreter(exp);
  const Map<String, num> map = {'x': 100.0, 'y': 12.0, 'z': 4};
  double result = expressionInterpreter.calculate(map);
  talker.info('Result: $result');
}