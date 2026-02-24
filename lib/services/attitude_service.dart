import 'dart:math';

class AttitudeService {
  int _calculationCount = 0;
  int _targetSassThreshold = 0;
  final Random _random = Random();

  // A list of fun, sassy responses to give instead of the answer
  final List<String> _sassyQuotes = [
    "I'm on a break. Figure it out yourself.",
    "Do I look like a math professor to you?",
    "Ugh, 42. It's always 42. Now leave me alone.",
    "My circuits hurt. Ask Google.",
    "Error 404: Motivation not found.",
    "Seriously? Use your fingers.",
    "I calculate that you're annoying me."
  ];

  AttitudeService() {
    _setNewThreshold();
  }

  // Randomly sets the next interruption to be after 5, 6, or 7 calculations
  void _setNewThreshold() {
    _targetSassThreshold = _random.nextInt(3) + 5; 
  }

  // Call this right before you do the math. 
  // If it returns a String, show the string. If it returns null, do the math!
  String? tryGetSass() {
    _calculationCount++;
    
    if (_calculationCount >= _targetSassThreshold) {
      // Reset the counter and pick a new random target for next time
      _calculationCount = 0;
      _setNewThreshold();
      
      // Return a random sassy quote
      return _sassyQuotes[_random.nextInt(_sassyQuotes.length)];
    }
    
    // Returning null means "all good, proceed with the actual calculation"
    return null; 
  }
}
