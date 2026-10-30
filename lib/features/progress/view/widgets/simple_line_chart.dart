import 'package:flutter/material.dart';

import '../../model/progress_models.dart';

/// A minimal line chart drawn with Flutter's own CustomPainter — no
/// third-party chart package (spec section 24: "do not add a heavy
/// package unnecessarily"; this needs none at all). Plots real
/// ChartPoints only; the caller is responsible for passing an empty
/// list (never fabricated points) when there's no data.
class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({
    super.key,
    required this.points,
    required this.lineColor,
    this.maxY,
    this.height = 200,
  });

  final List<ChartPoint> points;
  final Color lineColor;

  /// Fixed upper bound for the Y axis (e.g. 100 for an accuracy chart).
  /// If null, scales to the highest value in [points].
  final double? maxY;

  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No data yet for this selection.',
            style: TextStyle(color: Theme.of(context).dividerColor),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _LineChartPainter(
          points: points,
          lineColor: lineColor,
          gridColor: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          maxY: maxY,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.lineColor,
    required this.gridColor,
    this.maxY,
  });

  final List<ChartPoint> points;
  final Color lineColor;
  final Color gridColor;
  final double? maxY;

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPadding = 8;
    const double bottomPadding = 4;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    final double highest =
        maxY ?? points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final double effectiveMax = highest <= 0 ? 1 : highest;

    // Grid lines (25/50/75/100%).
    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final double y = chartHeight - (chartHeight * i / 4);
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    if (points.length == 1) {
      // A single point: draw just a dot, no line to divide-by-zero on.
      final Offset center = Offset(
        leftPadding + chartWidth / 2,
        chartHeight - (points.first.value / effectiveMax * chartHeight),
      );
      canvas.drawCircle(center, 4, Paint()..color = lineColor);
      return;
    }

    final Path path = Path();
    final List<Offset> offsets = [];
    for (int i = 0; i < points.length; i++) {
      final double x = leftPadding + (chartWidth * i / (points.length - 1));
      final double y =
          chartHeight - (points[i].value / effectiveMax * chartHeight);
      offsets.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    final Paint dotPaint = Paint()..color = lineColor;
    for (final Offset o in offsets) {
      canvas.drawCircle(o, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.maxY != maxY;
  }
}
