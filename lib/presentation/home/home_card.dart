import 'package:flutter/material.dart';
import 'package:pomodorro/model/pomodorro_item.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({
    super.key,
    required this.pomodorroItem,
    this.colorA = 0xFF2A9D8F,
    this.colorB = 0xFFF4A261,
    this.animationDuration = 200,
    required this.onTap,
  });

  final PomodorroItem pomodorroItem;
  final int colorA;
  final int colorB;
  final int animationDuration;
  final void Function(PomodorroItem) onTap;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget.pomodorroItem),
      child: Focus(
        onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isFocused = true),
          onExit: (_) => setState(() => _isFocused = false),
          child: AnimatedContainer(
            duration: Duration(milliseconds: widget.animationDuration),
            curve: Curves.easeInOut,
            width: 200,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              // We switch between a solid grey and the linear gradient
              gradient:
                  _isFocused
                      ? LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Color(widget.colorA), Color(widget.colorB)],
                      )
                      : const LinearGradient(
                        colors: [Color(0xFFE0E0E0), Color(0xFFE0E0E0)],
                      ),
              boxShadow:
                  _isFocused
                      ? [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                      : [],
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: _isFocused ? Colors.white : Colors.black,
              ),
              child: Text(
                widget.pomodorroItem.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
