import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interval_timer/styles/app_colors.dart';

class DropdownRow extends StatelessWidget {
  final List<Map<String, dynamic>> dropdownProps;
  const DropdownRow({Key? key, required this.dropdownProps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dropdownProps.map((prop) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 10,
          ),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${prop['title']}',
                  style: const TextStyle(
                    color: AppColors.gray01,
                    fontSize: 18,
                  ),
                ),
                Container(
                  width: 0.3.sw,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<int>(
                    value: prop['value'],
                    dropdownColor: const Color.fromRGBO(255, 255, 255, 0.9),
                    style: const TextStyle(
                      color: AppColors.gray01,
                      fontSize: 18,
                    ),
                    onChanged: prop['onChanged'],
                    items: prop['items'],
                    borderRadius: BorderRadius.circular(12.r),
                    elevation: 0,
                    enableFeedback: true,
                    isExpanded: true,
                    underline: const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
