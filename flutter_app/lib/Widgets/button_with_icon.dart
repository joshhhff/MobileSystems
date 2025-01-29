import 'package:flutter/material.dart';

class ButtonWithIcon extends StatefulWidget {
  final Color? colour;
  final IconData? icon;
  final String text;
  final VoidCallback? onClick;

  const ButtonWithIcon({super.key, this.colour, this.icon, required this.text, this.onClick});

  @override
  State<ButtonWithIcon> createState() => _ButtonWithIconState();
}

class _ButtonWithIconState extends State<ButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      /* onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        );
      }, */
      onPressed: widget.onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.colour, // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      ),
      icon: Icon(
        widget.icon ?? Icons.add, // default to plus if no icon
        color: Colors.white,
      ),
      label: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
