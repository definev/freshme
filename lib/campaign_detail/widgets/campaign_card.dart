import 'package:flutter/material.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/fresh_widget/fresh_frame.dart';
import 'package:freshme/fresh_widget/fresh_progress_bar.dart';
import 'package:gap/gap.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({
    Key? key,
    required this.angle,
    required this.image,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.finishedGoal,
    required this.onTap,
  }) : super(key: key);

  final FreshAngle angle;
  final String image;
  final String category;
  final String title;
  final Widget subtitle;
  final double finishedGoal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: InkWell(
        onTap: onTap,
        child: FreshFrame(
          angle: angle,
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white12,
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        blendMode: BlendMode.srcOver,
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FreshChip(
                              onPressed: () {},
                              color: Colors.pinkAccent[700]!,
                              child: Text(category),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                                const Gap(10),
                                subtitle,
                                const Gap(5),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  children: [
                    const Gap(10),
                    FreshProgressBar(
                      percent: finishedGoal,
                      direction: Axis.horizontal,
                      length: 220 * 1.4 - 12,
                    ),
                    const Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text('Mục tiêu hoàn thành'),
                        Text(
                          '${finishedGoal * 100}%',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
