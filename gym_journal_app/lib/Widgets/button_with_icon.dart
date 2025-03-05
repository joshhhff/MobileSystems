import 'package:flutter/material.dart';

class ButtonWithIcon extends StatefulWidget {
  final Color? colour;
  final IconData? icon;
  final String text;
  final VoidCallback? onClick;
  final Color textColour;
  final Color? borderColour;

  const ButtonWithIcon({super.key, this.colour, this.icon, required this.text, required this.textColour, this.borderColour, this.onClick});

  @override
  State<ButtonWithIcon> createState() => _ButtonWithIconState();
}

class _ButtonWithIconState extends State<ButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.colour, // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          side: BorderSide(
            color: widget.borderColour ?? Colors.transparent, // Border color
            width: 1.0, // Border width
              ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      ),
      icon: Icon(
        widget.icon ?? Icons.add, // default to plus if no icon
        color: widget.textColour,
      ),
      label: Text(
        widget.text,
        style: TextStyle(
          color: widget.textColour,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
