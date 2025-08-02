import 'package:flutter/material.dart';
import 'package:trendy/profile_screen.dart';

class AccountOwnerProfile extends StatelessWidget {
  const AccountOwnerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(
                isOwner: false,
                isVip: true,
              ),
            ),
          );
        },
        child: const Icon(Icons.visibility),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('My Profile'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://i.imgur.com/3oEJMlB.png',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const ListTile(
                  leading: Icon(Icons.psychology),
                  title: Text('Personality Engine'),
                ),
                const ListTile(
                  leading: Icon(Icons.analytics),
                  title: Text('Analytics Dashboard'),
                ),
                const ListTile(
                  leading: Icon(Icons.palette),
                  title: Text('Theme Designer'),
                ),
                const ListTile(
                  leading: Icon(Icons.inventory_2),
                  title: Text('My Capsules'),
                ),
                const ListTile(
                  leading: Icon(Icons.memory),
                  title: Text('Memory Orb'),
                ),
                const ExpansionTile(
                  leading: Icon(Icons.control_camera),
                  title: Text('Floating Hub Controls'),
                  children: [
                    ListTile(
                      title: Text('Rearrange Hubs'),
                    ),
                    ListTile(
                      title: Text('Hide Hubs'),
                    ),
                  ],
                ),
                const ExpansionTile(
                  leading: Icon(Icons.monetization_on),
                  title: Text('Monetization Tools'),
                  children: [
                    ListTile(
                      title: Text('View Earnings'),
                    ),
                    ListTile(
                      title: Text('Manage Premium Vault'),
                    ),
                  ],
                ),
                const ExpansionTile(
                  leading: Icon(Icons.security),
                  title: Text('Privacy & Security Tools'),
                  children: [
                    ListTile(
                      title: Text('Control Visibility'),
                    ),
                    ListTile(
                      title: Text('Lock Profile'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
