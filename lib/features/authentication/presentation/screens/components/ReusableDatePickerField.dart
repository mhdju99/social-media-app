import 'package:flutter/material.dart';

class ReusableDatePickerField extends StatefulWidget {
  final String label;
  final IconData icon;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime?)? onSaved;
  final String? Function(DateTime?)? validator;

  const ReusableDatePickerField({
    super.key,
    this.label = 'اختر التاريخ',
    this.icon = Icons.calendar_today,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onSaved,
    this.validator,
  });

  @override
  State<ReusableDatePickerField> createState() =>
      _ReusableDatePickerFieldState();
}

class _ReusableDatePickerFieldState extends State<ReusableDatePickerField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _controller.dispose(); // منع تسرب الذاكرة
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? now,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? now,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w200,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.grey[300],
        prefixIcon: Icon(widget.icon),
      ),
      onTap: _selectDate,
      onSaved: (_) => widget.onSaved?.call(_selectedDate),
      validator: (_) => widget.validator?.call(_selectedDate),
    );
  }
}
