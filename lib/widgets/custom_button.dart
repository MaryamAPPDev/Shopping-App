import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buttonChild = isLoading
        ? SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          isOutlined
              ? (foregroundColor ?? theme.colorScheme.primary)
              : Colors.white,
        ),
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppTheme.sm),
        ],
        Text(text),
      ],
    );

    final style = isOutlined
        ? theme.outlinedButtonTheme.style?.copyWith(
      fixedSize: WidgetStateProperty.all(Size(width ?? double.infinity, height)),
    )
        : theme.elevatedButtonTheme.style?.copyWith(
      backgroundColor: backgroundColor != null
          ? WidgetStateProperty.all(backgroundColor)
          : null,
      foregroundColor: foregroundColor != null
          ? WidgetStateProperty.all(foregroundColor)
          : null,
      fixedSize: WidgetStateProperty.all(Size(width ?? double.infinity, height)),
    );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: buttonChild,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: buttonChild,
    );
  }
}

class IconButtonCustom extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  const IconButtonCustom({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.sm),
          child: Icon(
            icon,
            color: color ?? Theme.of(context).colorScheme.primary,
            size: size,
          ),
        ),
      ),
    );
  }
}