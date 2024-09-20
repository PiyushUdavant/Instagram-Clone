import'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child; // It is to make the LikeAnimation class it's parent
  final bool isAnimating; // To check is animation going on or not
  final Duration duration; // How long animation should continue
  final VoidCallback? onEnd; // To end the animation
  final bool smallLike; // To check whether Like IconButton clicked or not
  const LikeAnimation({
    super.key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
    });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation <double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this, 
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds ~/ 2
      )
      // ~/ : Divides the time by 2 and convert it into int
    ); 
    scale = Tween<double>(begin: 1 , end : 1.2).animate(controller);    
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) { 
    // To replace the old widget with new widget
    super.didUpdateWidget(oldWidget);

    if(widget.isAnimating != oldWidget.isAnimating){
      startAnimation();
    }
  }

  void startAnimation() async {
    if(widget.isAnimating || widget.smallLike){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds:200));

      if(widget.onEnd != null){
        widget.onEnd!();
      }
    }    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}