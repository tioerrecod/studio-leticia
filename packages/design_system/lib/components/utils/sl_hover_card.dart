import 'package:flutter/material.dart';
import '../shadows.dart';

class SLHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final List<BoxShadow> restingShadow;
  final List<BoxShadow> hoverShadow;

  const SLHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.restingShadow = SLShadows.elevation1,
    this.hoverShadow = SLShadows.elevation3,
  });

  @override
  State<SLHoverCard> createState() => _SLHoverCardState();
}

class _SLHoverCardState extends State<SLHoverCard> {
  bool _isHovered = false;

  Matrix4 _transform() {
    if (!_isHovered) return Matrix4.identity();
    final matrix = Matrix4.identity();
    matrix.translate(0, -2);
    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: _transform(),
          decoration: BoxDecoration(
            boxShadow: _isHovered ? widget.hoverShadow : widget.restingShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
