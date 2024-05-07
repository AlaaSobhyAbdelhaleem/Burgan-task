import 'package:flutter/material.dart';

enum ButtonType { primary, secondary }

class ButtonWidget extends StatefulWidget {
  final Function()? onTap;
  final ButtonType? type;
  final String? title;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool enable;

  const ButtonWidget({
    super.key,
    this.onTap,
    required this.type,
    this.title,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.enable = true,
  });

  @override
  ButtonWidgetState createState() => ButtonWidgetState();
}

class ButtonWidgetState extends State<ButtonWidget> {
  Widget getWidget() {
    InkWell widgetComponent;
    switch (widget.type!) {
      case ButtonType.primary:
        widgetComponent = InkWell(
          onTap: widget.onTap,
          child: Container(
            height: 56,
            width: widget.width,
            decoration: widget.enable
                ? BoxDecoration(
                    color: widget.backgroundColor ?? Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    color: Theme.of(context).indicatorColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
            child: Center(
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        );
        break;
      case ButtonType.secondary:
        widgetComponent = InkWell(
          onTap: widget.onTap,
          child: Container(
            height: 56,
            decoration: widget.enable
                ? BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                        color: widget.textColor != null ? widget.textColor! : Theme.of(context).primaryColor, width: 1),
                    color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor)
                : BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Theme.of(context).indicatorColor, width: 1),
                    color: Theme.of(context).scaffoldBackgroundColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
        break;
    }

    return widgetComponent;
  }

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }
}
