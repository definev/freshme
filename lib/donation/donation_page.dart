import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:freshme/camera/send_your_love_page.dart';
import 'package:freshme/campaign_detail/campaign_detail_page.dart';
import 'package:freshme/donation/dependencies.dart';
import 'package:freshme/donation/widgets/donation_app_bar.dart';
import 'package:freshme/fresh_widget/fresh_frame.dart';
import 'package:freshme/fresh_widget/fresh_text_button.dart';
import 'package:freshme/fresh_widget/fresh_search_box.dart';
import 'package:freshme/resources/resources.dart';
import 'package:gap/gap.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const DonationAppBar(),
            PaddedColumn(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 64),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let\'s share goodness',
                  style: Theme.of(context) //
                      .textTheme
                      .titleLarge!
                      .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(12),
                Text(
                  'Good people help each other',
                  style: Theme.of(context) //
                      .textTheme
                      .bodySmall!
                      .copyWith(
                        fontWeight: FontWeight.w200,
                      ),
                ),
                const Gap(15),
                const FreshSearchBox(),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DonationActionTile(
                      color: const Color(0xFFbfdadd),
                      image: Image.asset(Images.donation),
                      title: 'Donations',
                      onPressed: () {},
                    ),
                    DonationActionTile(
                      color: const Color(0xFFFFD5C9),
                      image: Image.asset(Images.photoCamera),
                      title: 'Send your love',
                      isCenter: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SendYourLovePage(),
                          ),
                        );
                      },
                    ),
                    DonationActionTile(
                      color: const Color(0xFFfde387).withOpacity(0.3),
                      image: Image.asset(Images.cardboard),
                      title: 'Raise Funds',
                      onPressed: () {},
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Campaign',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      FreshTextButton(
                        onPressed: () {},
                        text: 'See All',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const Gap(30),
                    itemCount: 4,
                    itemBuilder: (context, index) => CampaignDetailCard(
                      angle:
                          index % 2 == 0 ? FreshAngle.right : FreshAngle.left,
                      image:
                          'http://chungtadidau.com/wp-content/uploads/2016/07/quyen-gop-sach-giao-khoa-cho-tre-em-vung-cao-576.jpg',
                      category: 'Sức khỏe',
                      title: 'HÀNH TRÌNH ĐỎ BẮC NINH 2022',
                      subtitle: 'THPT Hàn Thuyên',
                      finishedGoal: 0.6,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CampaignDetailPage(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
