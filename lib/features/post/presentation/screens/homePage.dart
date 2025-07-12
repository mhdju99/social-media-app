import 'package:flutter/material.dart';
import 'package:social_media_app/features/post/presentation/screens/postDetails.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum PostCategory { all, images, videos, articles }

extension PostCategoryExt on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.all:
        return 'All';
      case PostCategory.images:
        return 'Images';
      case PostCategory.videos:
        return 'Videos';
      case PostCategory.articles:
        return 'Articles';
    }
  }
}

class _HomepageState extends State<Homepage> {
  PostCategory _selectedCategory = PostCategory.all;
  Widget _buildChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: PostCategory.values.map((category) {
        return Container(
          child: ChoiceChip(
            label: Text(
              category.label,
            ),
            selected: _selectedCategory == category,
            showCheckmark: false,
            surfaceTintColor: Colors.black,
            elevation: 1,
            side: BorderSide.none,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            selectedColor: const Color.fromARGB(255, 0, 224, 202),
            disabledColor: Colors.grey,
            backgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.all(10),
            labelStyle: TextStyle(
                color: _selectedCategory == category
                    ? Colors.white
                    : Colors.black),
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Text('المجتمع', style: TextStyle(color: Colors.grey[800])),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.grey[600]),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.grey[100],
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildChips(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 0),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostDetailsPage()),
                      );
                    },
                    child: PostCard(
                      username: 'د. حكيم الحكيم',
                      time: 'منذ 5 دقائق',
                      content:
                          'كنت أعاني من صداع شديد لأسابيع، ولكن بعد تجربة بعض النصائح من الدكتورة الحكيمة أ.ي، أشعر بتحسن كبير! #وداعا_للصداع #نصائح_طبية',
                      avatarUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAKvt_h7XNeQuygS26VtcqtMYhuOMRv8kgOwb9eKQYtdWyDXKCSCE_uo_FHSlQqiznAH-Pdw6YxiIA6Pw1iXaJj1-OMS3bxPgxkkpmcdCwgxbIIBSXB5osonvYf2ZQTqq4RunmRayPTzknDXaMPU5P3uvzvmEnXOsNqNbBGzabTaPXCZ3bB4fef1Jwiv0mkbPb9xZcri9NlYwRYHQSEGPRQeD5BTNNX_2lV_VL2UO-WuaKgdNuRPmZ7YYjI0_0PlqdZY_n4Omw-Dg0',
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAjPhKdfw3TPm63nmopt6yWe_LyrLTt3Ug8q5409WxggdrIJiFC1uIP-SY2wQN7Sf9ApJ6Wr67xO3pzNuud1zZsCH1yhtaiN2xABlI_4onQe-g-MxRcLoD6RsDlh-Zt7JvdUxcrFw0BuVA6rJiQbbHY8Xjw1HMnZQruHJYkckaBp3vDeqpFajePIHs52Sf7vgpjyBKjDuPRCwijn6dDaJGShjCPNcdQBZVtPJUfcEjD4XyFnlW4AqR5TEKOWSxVhbtOKNb4u3muYw4',
                      likes: '1.8 ألف',
                      comments: '235',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PostCard(
                    username: 'د. حكيم الحكيم',
                    time: 'منذ 5 دقائق',
                    content:
                        'كنت أعاني من صداع شديد لأسابيع، ولكن بعد تجربة بعض النصائح من الدكتورة الحكيمة أ.ي، أشعر بتحسن كبير! #وداعا_للصداع #نصائح_طبية',
                    avatarUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAKvt_h7XNeQuygS26VtcqtMYhuOMRv8kgOwb9eKQYtdWyDXKCSCE_uo_FHSlQqiznAH-Pdw6YxiIA6Pw1iXaJj1-OMS3bxPgxkkpmcdCwgxbIIBSXB5osonvYf2ZQTqq4RunmRayPTzknDXaMPU5P3uvzvmEnXOsNqNbBGzabTaPXCZ3bB4fef1Jwiv0mkbPb9xZcri9NlYwRYHQSEGPRQeD5BTNNX_2lV_VL2UO-WuaKgdNuRPmZ7YYjI0_0PlqdZY_n4Omw-Dg0',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAjPhKdfw3TPm63nmopt6yWe_LyrLTt3Ug8q5409WxggdrIJiFC1uIP-SY2wQN7Sf9ApJ6Wr67xO3pzNuud1zZsCH1yhtaiN2xABlI_4onQe-g-MxRcLoD6RsDlh-Zt7JvdUxcrFw0BuVA6rJiQbbHY8Xjw1HMnZQruHJYkckaBp3vDeqpFajePIHs52Sf7vgpjyBKjDuPRCwijn6dDaJGShjCPNcdQBZVtPJUfcEjD4XyFnlW4AqR5TEKOWSxVhbtOKNb4u3muYw4',
                    likes: '1.8 ألف',
                    comments: '235',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PostCard(
                    username: 'د. حكيم الحكيم',
                    time: 'منذ 5 دقائق',
                    content:
                        'كنت أعاني من صداع شديد لأسابيع، ولكن بعد تجربة بعض النصائح من الدكتورة الحكيمة أ.ي، أشعر بتحسن كبير! #وداعا_للصداع #نصائح_طبية',
                    avatarUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAKvt_h7XNeQuygS26VtcqtMYhuOMRv8kgOwb9eKQYtdWyDXKCSCE_uo_FHSlQqiznAH-Pdw6YxiIA6Pw1iXaJj1-OMS3bxPgxkkpmcdCwgxbIIBSXB5osonvYf2ZQTqq4RunmRayPTzknDXaMPU5P3uvzvmEnXOsNqNbBGzabTaPXCZ3bB4fef1Jwiv0mkbPb9xZcri9NlYwRYHQSEGPRQeD5BTNNX_2lV_VL2UO-WuaKgdNuRPmZ7YYjI0_0PlqdZY_n4Omw-Dg0',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAjPhKdfw3TPm63nmopt6yWe_LyrLTt3Ug8q5409WxggdrIJiFC1uIP-SY2wQN7Sf9ApJ6Wr67xO3pzNuud1zZsCH1yhtaiN2xABlI_4onQe-g-MxRcLoD6RsDlh-Zt7JvdUxcrFw0BuVA6rJiQbbHY8Xjw1HMnZQruHJYkckaBp3vDeqpFajePIHs52Sf7vgpjyBKjDuPRCwijn6dDaJGShjCPNcdQBZVtPJUfcEjD4XyFnlW4AqR5TEKOWSxVhbtOKNb4u3muYw4',
                    likes: '1.8 ألف',
                    comments: '235',
                  ),
                )
                // باقي البوستات...
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;

  const FilterChipWidget(
      {super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        backgroundColor: selected ? Colors.teal : Colors.grey[200],
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String username;
  final String time;
  final String content;
  final String avatarUrl;
  final String imageUrl;
  final String likes;
  final String comments;

  const PostCard({
    super.key,
    required this.username,
    required this.time,
    required this.content,
    required this.avatarUrl,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800])),
                    Text(time,
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                const Spacer(),
                Icon(Icons.more_horiz, color: Colors.grey[500])
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl, height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt, size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(likes, style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 12),
                    Icon(Icons.chat_bubble_outline,
                        size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(comments, style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 12),
                    Icon(Icons.share, size: 18, color: Colors.grey[500]),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.bookmark_border,
                        size: 18, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text('حفظ', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
