import 'package:community_material_icon/community_material_icon.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:freshme/fresh_widget/dotted_button.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/fresh_widget/fresh_frame.dart';
import 'package:gap/gap.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ColoredBox(
            color: Colors.transparent,
            child: SafeArea(
              child: SizedBox(
                height: 56,
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(CommunityMaterialIcons.arrow_left),
                      ),
                    ),
                    Text(
                      'Chi tiết chiến dịch',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(CommunityMaterialIcons.share),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                AspectRatio(
                  aspectRatio: 1.4,
                  child: FreshFrame(
                    angle: FreshAngle.balance,
                    child: SizedBox.expand(
                      child: Image.network(
                        'https://www.socialtables.com/wp-content/uploads/2016/10/iStock-540095978.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Text(
                  'Chương trình tình nguyện "Máu đỏ 2022"',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.7,
                        letterSpacing: 1.3,
                        wordSpacing: 2,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CLB Máu - trường ĐH Hà Nội',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    InkWell(
                      onTap: () {},
                      child: const SizedBox(
                        height: 48,
                        width: 48,
                        child: Icon(
                          CommunityMaterialIcons.heart_outline,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SeparatedRow(
                          separatorBuilder: () => const Gap(10),
                          children: [
                            FreshChip(
                              onPressed: () {},
                              color: const Color.fromARGB(255, 178, 41, 31),
                              child: const Text('Sức khỏe'),
                            ),
                            FreshChip(
                              onPressed: () {},
                              color: Colors.green,
                              child: const Text('Môi trường'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                const SizedBox(height: 600),
                SafeArea(
                  child: FreshDottedButton(
                    child: const Text('Ủng hộ'),
                    onPressed: () {},
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
