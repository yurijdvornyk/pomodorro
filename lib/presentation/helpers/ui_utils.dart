class UiUtils {
  static int getSliderDivisionsCount(double min, double max, double step) =>
      ((max - min) / step).toInt();
}