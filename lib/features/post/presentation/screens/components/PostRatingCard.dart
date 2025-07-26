// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/material.dart';



class PostRatingCard extends StatefulWidget {
  final void Function(int rating) onRated;

  const PostRatingCard({super.key, required this.onRated});

  @override
  _PostRatingCardState createState() => _PostRatingCardState();
}

class _PostRatingCardState extends State<PostRatingCard> {
  int? selectedRating;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How do you rate this post?",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            GridView.count(
              padding: const EdgeInsets.only(top: 5),
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 2, // لضبط حجم الأزرار
              children: List.generate(10, (index) {
                final rating = index + 1;
                final isSelected = selectedRating == rating;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = rating;
                    });
                    widget.onRated(rating);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? Colors.blue : Colors.grey[200],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: Text(rating.toString()),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
