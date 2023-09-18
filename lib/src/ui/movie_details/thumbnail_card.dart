import 'package:flutter/material.dart';

class ThumbnailCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final VoidCallback? onPressed;
  final Brightness rippleBrightness;
  final double borderRadiusValue;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final Shadow shadow;
  final BoxBorder? boxBorder;

  const ThumbnailCard({
    Key? key,
    this.child,
    this.padding,
    this.onPressed,
    this.rippleBrightness = Brightness.light,
    this.borderRadiusValue = 8.0,
    this.backgroundColor = Colors.transparent,
    this.backgroundGradient, 
    this.shadow = Shadow.normal,
    this.boxBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      // clip corners
      child: Stack(
        children: <Widget>[
          Container(
            padding: padding ?? EdgeInsets.zero,
            child: child ??
                // show empty card if no child provided
                Container(
                  width: 200,
                  height: 100,
                ),
          ),

          // Flat button on top if onPressed provided
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: onPressed == null
                ? SizedBox()
                : TextButton(
                    onPressed: onPressed,
                    child: SizedBox(),
                  ),
          ),
        ],
      ),
    );
  }
}

enum Shadow {
  normal,
  large,
  soft,
  none
}
