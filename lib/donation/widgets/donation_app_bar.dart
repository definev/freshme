import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DonationAppBar extends StatelessWidget {
  const DonationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRH61cjT9_c32YY_rDdPPa35oK-mrdeCJtspA&usqp=CAU',
                  ),
                ),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good afternoon',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Huy Nguyen',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 48,
            width: 48,
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    CommunityMaterialIcons.bell_outline,
                    size: 28,
                  ),
                ),
                Center(
                  child: Transform.translate(
                    offset: const Offset(7, -6),
                    child: SizedBox(
                      height: 14,
                      width: 14,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                          ),
                          color: Colors.redAccent.shade100,
                        ),
                        child: Center(
                          child: Text(
                            '1',
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      color: Colors.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
