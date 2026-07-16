import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class QuickMenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const QuickMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });
}

/// AssistiveTouch Radial Style Expandable Quick Menu Floating Button
class AssistiveQuickMenu extends StatefulWidget {
  final List<QuickMenuItem> items;
  final String heroTag;
  final double radius;

  const AssistiveQuickMenu({
    super.key,
    required this.items,
    this.heroTag = 'assistive_quick_menu',
    this.radius = 85.0,
  });

  @override
  State<AssistiveQuickMenu> createState() => _AssistiveQuickMenuState();
}

class _AssistiveQuickMenuState extends State<AssistiveQuickMenu>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    setState(() {
      _isOpen = true;
    });
    _portalController.show();
    _controller.forward();
  }

  void _close() {
    if (!_isOpen) return;
    setState(() {
      _isOpen = false;
    });
    _controller.reverse().then((_) {
      if (!mounted) return;
      _portalController.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: (context) {
        final count = widget.items.length;
        return CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.bottomRight,
          child: Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none,
            children: [
              ...widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                // Calculate angle along 90 deg arc (from 90° top to 180° left)
                double angle;
                if (count == 1) {
                  angle = math.pi * 3 / 4; // 135° (top-left)
                } else {
                  angle = (math.pi / 2) + (index * (math.pi / 2) / (count - 1));
                }

                // Target offsets relative to bottom-right trigger
                final dx = widget.radius * math.cos(angle);
                final dy = -widget.radius * math.sin(angle);

                final itemInterval = Interval(
                  (index / count) * 0.3,
                  1.0,
                  curve: Curves.elasticOut,
                );

                final itemAnimation = CurvedAnimation(
                  parent: _controller,
                  curve: itemInterval,
                  reverseCurve: Curves.easeIn,
                );

                return AnimatedBuilder(
                  animation: itemAnimation,
                  builder: (context, child) {
                    final progress = itemAnimation.value;
                    final scale = progress.clamp(0.0, 1.0);
                    final opacity = progress.clamp(0.0, 1.0);

                    if (progress <= 0.01) return const SizedBox.shrink();

                    final rightPos = -dx * progress + 5.0;
                    final bottomPos = -dy * progress + 5.0;

                    return Positioned(
                      right: rightPos,
                      bottom: bottomPos,
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              heroTag: '${widget.heroTag}_radial_$index',
                              backgroundColor: item.color ?? AppColors.primary,
                              tooltip: item.label,
                              elevation: 5,
                              onPressed: () {
                                _close();
                                item.onTap();
                              },
                              child: Icon(item.icon,
                                  color: Colors.white, size: 24),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: FloatingActionButton(
          heroTag: widget.heroTag,
          backgroundColor: _isOpen ? AppColors.error : AppColors.primary,
          elevation: 6,
          onPressed: _toggle,
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Icon(
              _isOpen ? Icons.close : Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
