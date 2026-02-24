import 'package:math_expressions/math_expressions.dart';

class MathEngine {
  /// Takes a string like "5+5" or "10÷2" and calculates the result.
  String calculate(String equation) {
    try {
      // The UI will use pretty symbols (× and ÷), but the math engine 
      // needs standard computer symbols (* and /). We swap them out here.
      String finalEquation = equation.replaceAll('×', '*').replaceAll('÷', '/');
      
      Parser p = Parser();
      Expression exp = p.parse(finalEquation);
      ContextModel cm = ContextModel();
      
      // Do the actual calculation
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Clean up the output: If the answer is 5.0, chop off the decimal and return "5"
      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }
      
      // If it's a long decimal, cap it at 6 places so it doesn't break the UI design
      return double.parse(eval.toStringAsFixed(6)).toString();
      
    } catch (e) {
      // If the user typed something invalid like "5++5", catch the crash gracefully
      return "Error";
    }
  }
}

