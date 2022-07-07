import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DonationActionTile extends StatelessWidget {
  const DonationActionTile({
    Key? key,
    required this.image,
    this.isCenter = false,
    required this.title,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  final Widget image;
  final String title;
  final Color color;
  final bool isCenter;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isCenter)
          Transform.scale(
            scale: 1.3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 56,
                  width: 56,
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 60,
                      child: image,
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Transform.translate(
            offset: const Offset(-10, 0),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(30),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  height: 56,
                  width: 56,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Transform.translate(
                      offset: const Offset(20, 10),
                      child: SizedBox(
                        height: 60,
                        child: image,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        const Gap(20),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
      ],
    );
  }
}
