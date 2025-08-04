import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://i.imgur.com/3oEJMlB.png'),
            ),
            title: Text('Username'),
            subtitle: Text('Location'),
          ),
          Image.network('https://i.imgur.com/3oEJMlB.png'),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('This is a post caption.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
            ],
          ),
        ],
      ),
    );
  }
}
