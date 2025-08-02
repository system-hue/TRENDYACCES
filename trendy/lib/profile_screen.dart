import 'package:flutter/material.dart';
import 'package:trendy/widgets/account_owner_profile.dart';
import 'package:trendy/widgets/visitor_profile.dart';

class ProfileScreen extends StatelessWidget {
  final bool isOwner;
  final bool isVip;

  const ProfileScreen({super.key, required this.isOwner, this.isVip = false});

  @override
  Widget build(BuildContext context) {
    return isOwner
        ? const AccountOwnerProfile()
        : VisitorProfile(isVip: isVip);
  }
}
