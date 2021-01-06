import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// https://www.youtube.com/watch?v=afBmGC63iIQ
/// Flutter Responsive UI | Learning Platform App - Part 1
/// Techie Blossom
class SizeConfig {
  static double _screenHeight;
  static double _blockHeight = 0;

  static double textMultiplier;

  void init(BoxConstraints constraints) {
    _screenHeight = constraints.maxHeight;

    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;

    /// print("Block Height");
    /// print(_blockHeight);

    /// By dividing by 100 above we break down the UI height in units called
    /// "Blocks." We design the UI on a specific device the way we like
    /// (ex: iPhone Max). We then take the size of the text that we like
    /// on that device, Ex: 30. We take the number of blocks in the height
    /// (9.26 for iPhone Max) and multiple it by a number that will get
    /// close to 30. So for a 30 size text the actual text we would use would
    /// be: textMultiplier * 3.25.
    /// (9.26 * 3.25 = 30)
  }
}
