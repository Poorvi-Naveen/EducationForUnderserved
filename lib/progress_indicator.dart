import 'package:flutter/material.dart';

class CourseProgressIndicator extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  final Color progressColor;
  final Color backgroundColor;
  final double height;

  const CourseProgressIndicator({
    super.key,
    required this.progress,
    this.progressColor = Colors.purple,
    this.backgroundColor = Colors.grey,
    this.height = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(
            alpha: 0.2,
          ), // More subtle background opacity
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(
                  0.0,
                  1.0,
                ), // Ensure progress stays within limits
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        progressColor,
                        progressColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
