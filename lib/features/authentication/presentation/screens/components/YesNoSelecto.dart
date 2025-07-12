import 'package:flutter/material.dart';

class DoctorPatientSelector extends FormField<bool> {
  DoctorPatientSelector({
    super.key,
    super.initialValue,
    required String title,
    super.onSaved,
    super.validator,
  }) : super(
          builder: (FormFieldState<bool> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => state.didChange(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: state.value == true
                                ? Colors.deepPurple
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.medical_services,
                                  size: 20,
                                  color: state.value == true
                                      ? Colors.white
                                      : Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                "Doctor",
                                style: TextStyle(
                                  color: state.value == true
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
                        onTap: () => state.didChange(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: state.value == false
                                ? Colors.deepPurple
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person_outline,
                                  size: 20,
                                  color: state.value == false
                                      ? Colors.white
                                      : Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                " Patient",
                                style: TextStyle(
                                  color: state.value == false
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
