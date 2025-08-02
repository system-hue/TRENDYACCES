import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileFooter extends StatefulWidget {
  const ProfileFooter({super.key});

  @override
  State<ProfileFooter> createState() => _ProfileFooterState();
}

class _ProfileFooterState extends State<ProfileFooter> {
  bool _aiBoost = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: SizedBox(
                      width: 200,
                      height: 200,
                      child: QrImageView(
                        data: 'https://www.jessicasmith.com',
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.qr_code),
          ),
          const Text('www.jessicasmith.com'),
          Switch(
            value: _aiBoost,
            onChanged: (value) {
              setState(() {
                _aiBoost = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
