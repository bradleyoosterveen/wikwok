extension DoubleExtension on double {
  double mapValue(
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) =>
      (this - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}
