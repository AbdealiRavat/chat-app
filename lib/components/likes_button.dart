import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LikesButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  LikesButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.grey),
    );
  }
}
