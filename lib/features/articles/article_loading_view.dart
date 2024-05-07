import 'package:burgan_task/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';

class ArticleLoadingView extends StatelessWidget {
  const ArticleLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      separatorBuilder: (context, index) => const SizedBox(
        width: 4,
      ),
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ShimmerWidget(
                  height: 180,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      height: 18,
                      width: 120,
                    ),
                    ShimmerWidget(
                      height: 18,
                      width: 120,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                ShimmerWidget(
                  height: 25,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ShimmerWidget(
                        height: 40,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    ShimmerWidget(
                      height: 40,
                      width: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
