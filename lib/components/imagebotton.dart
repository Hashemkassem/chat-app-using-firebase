import 'package:flutter/material.dart';

class ImageBotton extends StatelessWidget {
  const ImageBotton({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.grey[300]),
      padding: const EdgeInsets.all(20),

      child: Row(
        children: [
          Image.asset(
            imagePath,
            height: MediaQuery.of(context).size.height * 0.06,
          ),
        ],
      ),
    );
  }
}
