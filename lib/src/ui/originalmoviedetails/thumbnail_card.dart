import 'package:flutter/material.dart';

class ThumbnailCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Function onPressed;
  final Brightness rippleBrightness;
  final double borderRadiusValue;
  final Color backgroundColor;
  final Gradient backgroundGradient;
  final Shadow shadow;
  final BoxBorder boxBorder;

  const ThumbnailCard({
    Key key,
    this.child,
    this.padding,
    this.onPressed,
    this.rippleBrightness = Brightness.light,
    this.borderRadiusValue = 0.0,
    this.backgroundColor = Colors.transparent,
    this.backgroundGradient, 
    this.shadow = Shadow.normal,
    this.boxBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 10.0),
      duration: Duration(milliseconds: 350),
      // clip corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusValue),
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
                  : FlatButton(
                      colorBrightness: rippleBrightness,
                      onPressed: onPressed,
                      child: SizedBox(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<BoxShadow> _getShadows(){

    switch(shadow){
      case Shadow.normal:
        return [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 15,
            color: Colors.black12,
          )
        ];
        break;
      case Shadow.large:
        return [
          BoxShadow(
            offset: Offset(0, 15),
            blurRadius: 35,
            color: Color(0x12000000),
          )
        ];
        break;
      case Shadow.soft:
        return [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 15,
            color: Color(0x12000000),
          )
        ];
        break;
      case Shadow.none:
        return [];
        break;
    }

    return [];
  }
}

enum Shadow {
  normal,
  large,
  soft,
  none
}
