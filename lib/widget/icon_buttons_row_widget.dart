import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class IconButtonRow extends StatelessWidget {
  final List<Map<String, dynamic>> iconButtonProps;
  const IconButtonRow({Key? key, required this.iconButtonProps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconButtonProps.map((prop) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: prop['icon'],
                          iconSize: prop['iconSize'] ?? 60,
                          color: Colors.white,
                          disabledColor: Colors.white.withOpacity(0.5),
                          onPressed: prop['disabled'] == true
                              ? null
                              : () {
                                  Vibration.vibrate(duration: 10);
                                  prop['onPressed']();
                                },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                prop['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
