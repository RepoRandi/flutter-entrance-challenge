import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    Key? key,
    this.buttonColor,
    this.borderColor,
    this.textColor,
    this.iconSource,
    this.icon,
    this.iconSize,
    required this.onClick,
    required this.textLabel,
    this.side,
  }) : super(key: key);

  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final String? iconSource;
  final IconData? icon;
  final double? iconSize;
  final Function onClick;
  final String textLabel;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: borderColor != null
            ? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 1.5, color: borderColor!),
        )
            : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        side: side,
      ),
      onPressed: () {
        onClick();
      },
      icon: (iconSource != null)
          ? Image.asset(
        iconSource ?? "",
        height: iconSize ?? 24,
        width: iconSize ?? 24,
      )
          : icon != null
          ? Icon(icon, size: iconSize ?? 24)
          : const SizedBox.shrink(),
      label: Text(
        textLabel,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
