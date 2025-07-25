import 'package:flutter/material.dart';

class DoctorPatientSelector extends FormField<String> {
  DoctorPatientSelector({
    super.key,
    // super.initialValue,
     String? title,
    required Map<String, IconData> items,
    super.onSaved,
    super.validator,
  }) : super(
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              if(title !=null)
                Text(title, style: const TextStyle(fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => state.didChange(items.keys.first),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: state.value == items.keys.first
                                ? Colors.deepPurple
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(items.values.first,
                                  size: 20,
                                  color: state.value == items.keys.first
                                      ? Colors.white
                                      : Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                               items.keys.first,
                                style: TextStyle(
                                  color: state.value == items.keys.first
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => state.didChange(items.keys.last),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: state.value == items.keys.last
                                ? Colors.deepPurple
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(items.values.last,
                                  size: 20,
                                  color: state.value == items.keys.last
                                      ? Colors.white
                                      : Colors.black54),
                              const SizedBox(width: 6),
                              Text(  items.keys.last
                               ,
                                style: TextStyle(
                                  color: state.value == items.keys.last
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );
}
