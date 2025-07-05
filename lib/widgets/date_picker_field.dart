import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat; // 'dd/MM/yyyy' or 'yyyy-MM-dd'

  const DatePickerField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText = 'Chọn ngày',
    this.prefixIcon = Icons.calendar_today,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'dd/MM/yyyy',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF2196F3),
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          if (dateFormat == 'dd/MM/yyyy') {
            controller.text =
                "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          } else if (dateFormat == 'yyyy-MM-dd') {
            controller.text =
                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          }
        }
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            prefixIcon: Icon(prefixIcon),
            suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF2196F3)),
          ),
          validator:
              validator ??
              (v) => v == null || v.isEmpty ? 'Vui lòng chọn ngày' : null,
        ),
      ),
    );
  }
}
