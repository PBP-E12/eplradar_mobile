import 'package:flutter/material.dart';

class ClubStats extends StatelessWidget {
  const ClubStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: const Center(
        child: Text('Stats Page Content'),
      ),
    );
  }
}