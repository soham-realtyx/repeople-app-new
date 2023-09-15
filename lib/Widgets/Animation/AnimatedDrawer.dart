import 'package:flutter/material.dart';

class AnimatedDrawer extends StatefulWidget {
  final Widget? child;
  final Duration? duration;
  final Offset? offset;

  const AnimatedDrawer({super.key, this.child,this.duration,this.offset});

  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer> with SingleTickerProviderStateMixin{

 late AnimationController animationController;
 late Animation<Offset> animation;

  @override
  void initState() {

    animationController = AnimationController(vsync: this,duration: widget.duration);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.decelerate);
    animation = Tween<Offset>(begin: widget.offset,end: Offset.zero).animate(curvedAnimation);

    animationController.forward();

    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: widget.child,
    );
  }
}
