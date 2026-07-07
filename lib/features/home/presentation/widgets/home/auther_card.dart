import 'package:flutter/material.dart';
import 'package:readora/features/home/data/models/auther_model.dart';

class AuthorCard extends StatelessWidget {
  final AuthorModel author;

  const AuthorCard({Key? key, required this.author}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            author.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          if (author.bio != null) ...[
            const SizedBox(height: 4),
            Text(
              author.bio!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
