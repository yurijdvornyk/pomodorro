import 'package:flutter/material.dart';

class DurationSlider extends StatefulWidget {
  const DurationSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 60,
  });

  /// Current value expressed in minutes.
  final int value;

  /// Called when the user moves the slider.
  final ValueChanged<int> onChanged;

  final int min;
  final int max;

  @override
  State<DurationSlider> createState() => _DurationSliderState();
}

class _DurationSliderState extends State<DurationSlider> {
  late double _dragStartX;
  late int _startValue;

  void _handleDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
    _startValue = widget.value;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final dx = details.globalPosition.dx - _dragStartX;
    final change = (dx / 4).round();
    var newValue = _startValue + change;
    if (newValue < widget.min) {
      newValue = widget.min;
    } else  if (newValue > widget.max) {
      newValue = widget.max;
    }
    if (newValue != widget.value) {
      widget.onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      child: SizedBox(
        height: 60,
        child: CustomPaint(
          painter: _SliderPainter(
            value: widget.value,
            min: widget.min,
            max: widget.max,
            textStyle: Theme.of(context).textTheme.headlineMedium!,
          ),
          child: Center(
            child: Text(
              '${widget.value}',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliderPainter extends CustomPainter {
  _SliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.textStyle,
  });

  final int value;
  final int min;
  final int max;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[400]!
          ..strokeWidth = 1;

    const tickSpacing = 5.0;
    const longTick = 8.0;
    const shortTick = 4.0;

    // draw ticks across width
    final center = size.width / 2;
    final totalTicks = ((max - min) * tickSpacing).toInt();
    // Instead of drawing all ticks, draw enough to fill area around center
    final visibleTicks = (size.width / tickSpacing).ceil();
    final startTickIndex = value - (visibleTicks ~/ 2);

    for (int i = 0; i <= visibleTicks; i++) {
      final tickValue = startTickIndex + i;
      final x = center + (i - visibleTicks / 2) * tickSpacing;
      if (tickValue < min || tickValue > max) continue;
      final isLong = tickValue % 5 == 0;
      final tickHeight = isLong ? longTick : shortTick;
      canvas.drawLine(
        Offset(x, size.height / 2 - tickHeight / 2),
        Offset(x, size.height / 2 + tickHeight / 2),
        paint,
      );
    }

    // draw central indicator
    final indicatorPaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 2;
    canvas.drawLine(
      Offset(center, 0),
      Offset(center, size.height),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SliderPainter old) {
    return old.value != value || old.min != min || old.max != max;
  }
}
