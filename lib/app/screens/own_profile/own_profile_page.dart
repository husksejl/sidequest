import 'package:flutter/material.dart';
import '../../shared/custom_bottom_nav.dart';

class OwnProfilePage extends StatelessWidget {
  const OwnProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050608),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Own Profile Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4), //muss drinnen bleiben - adresse für die navbar
    );
  }
}