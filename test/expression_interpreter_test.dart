import 'package:test/test.dart';
import '../interpreter/expression_interpreter.dart';

void main() {
  group('Expression Interpreter', () {

    String exp1 = '-40/(x-92)*2+5*(7-z)*y';
    ExpressionInterpreter interpreter1 = ExpressionInterpreter(exp1);
    Map<String, double> map1 = {'x':100.0, 'y':12.0, 'z':4.0};

    test('test without spaces', () {
      expect(interpreter1.calculate(map1), 170);
    });

    String exp2 = '-1024/y/2/2/2/2/x/2';
    ExpressionInterpreter interpreter2 = ExpressionInterpreter(exp2);
    Map<String, double> map2 = {'x':2.0, 'y':4.0};

    test('test multi division', () {
      expect(interpreter2.calculate(map2), -4);
    });

    String exp3 = '-10 + (100 - x / y - z * (5 +     y ) ) * (x + y )/2 - 5*x';
    ExpressionInterpreter interpreter3 = ExpressionInterpreter(exp3);
    Map<String, double> map3 = {'x':2.0, 'y':4.0, 'z':5.0};

    test('test extra spaces sustainability', () {
      expect(interpreter3.calculate(map3), 143.5);
    });

    String exp4 = 'a*a + b*b';
    ExpressionInterpreter interpreter4 = ExpressionInterpreter(exp4);
    Map<String, double> map4 = {'a':3.0, 'b':4.0};

    test('test simple', () {
      expect(interpreter4.calculate(map4), 25);
    });

    String exp5 = 'a*a + 2*a*b + b*b';
    ExpressionInterpreter interpreter5 = ExpressionInterpreter(exp5);
    Map<String, double> map5 = {'a':3.0, 'b':4.0};

    test('test square of sum', () {
      expect(interpreter5.calculate(map5), 49);
    });

  });

}