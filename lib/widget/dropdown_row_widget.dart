import 'package:flutter/material.dart';

class DropdownRow extends StatelessWidget {
  final List<Map<String, dynamic>> dropdownProps;
  const DropdownRow({Key? key, required this.dropdownProps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dropdownProps.map((prop) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${prop['title']} :',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 10),
            DropdownButton<int>(
              value: prop['value'],
              dropdownColor: const Color.fromARGB(255, 40, 40, 40),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              onChanged: prop['onChanged'],
              items: prop['items'],
            ),
          ],
        );
      }).toList(),
    );
  }
}
