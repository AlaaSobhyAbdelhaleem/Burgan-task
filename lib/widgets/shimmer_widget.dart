import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key, this.width, this.height, this.baseColor, this.highlightColor});
  final double? width;
  final double? height;
  final Color? baseColor;
  final Color? highlightColor;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 2000),
      direction: ShimmerDirection.ltr,
      baseColor: baseColor ?? const Color(0x33DBDBDB),
      highlightColor: highlightColor ?? const Color(0xFFDBDBDB),
      child: Container(
        width: width ?? 200.0,
        height: height ?? 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
