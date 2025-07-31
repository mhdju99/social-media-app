import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String selectedGender = 'Male';
  double minAge = 18;
  double maxAge = 50;

  final List<String> topics = [
    "Anxiety & Stress Management",
    "Depression & Mood Disorders",
    "Relationships & Interpersonal Issues",
    "Self-Esteem & Identity",
    "Trauma & PTSD",
    "Growth, Healing & Motivation",
  ];
  final Set<String> selectedTopics = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Posts'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Gender
            Text('Post Owner Gender:'),
            Row(
              children: [
                Radio<String>(
                  value: 'male',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                Text('Male'),
                Radio<String>(
                  value: 'female',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                Text('Female'),
              ],
            ),

            SizedBox(height: 20),

            // ✅ Age range
            Text('Post Owner Age: ${minAge.round()} - ${maxAge.round()}'),
            RangeSlider(
              min: 10,
              max: 100,
              divisions: 90,
              labels: RangeLabels('${minAge.round()}', '${maxAge.round()}'),
              values: RangeValues(minAge, maxAge),
              onChanged: (RangeValues values) {
                setState(() {
                  minAge = values.start;
                  maxAge = values.end;
                });
              },
            ),

            SizedBox(height: 20),

            // ✅ Topics (ChoiceChips)
            Text('Topics:'),
            Wrap(
              spacing: 8.0,
              children: topics.map((topic) {
                final isSelected = selectedTopics.contains(topic);
                return ChoiceChip(
                  label: Text(topic),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedTopics.add(topic);
                      } else {
                        selectedTopics.remove(topic);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Apply the filters here if needed
            print('Gender: $selectedGender');
            print('Age Range: $minAge - $maxAge');
            print('Topics: $selectedTopics');
            Navigator.of(context).pop();
          },
          child: Text('Apply'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
