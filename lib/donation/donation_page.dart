import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:freshme/donation/widgets/donation_app_bar.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/fresh_widget/fresh_frame.dart';
import 'package:freshme/fresh_widget/fresh_text_button.dart';
import 'package:freshme/fresh_widget/fresh_progress_bar.dart';
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
                    ),
                    DonationActionTile(
                      color: const Color(0xFFFFD5C9),
                      image: Image.asset(Images.photoCamera),
                      title: 'Send your love',
                      isCenter: true,
                    ),
                    DonationActionTile(
                      color: const Color(0xFFfde387).withOpacity(0.3),
                      image: Image.asset(Images.cardboard),
                      title: 'Raise Funds',
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
                    itemBuilder: (context, index) => AspectRatio(
                      aspectRatio: 1.4,
                      child: FreshFrame(
                        angle:
                            index % 2 == 0 ? FreshAngle.right : FreshAngle.left,
                        child: Column(
                          children: [
                            Flexible(
                              flex: 5,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(
                                    child: ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
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
                                        'http://chungtadidau.com/wp-content/uploads/2016/07/quyen-gop-sach-giao-khoa-cho-tre-em-vung-cao-576.jpg',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FreshChip(
                                            onPressed: () {},
                                            color: Colors.pinkAccent[700]!,
                                            child: const Text('Giáo dục'),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Trái tim cho em',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              const Gap(10),
                                              Text(
                                                'Lai Châu -> Lạng Sơn',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
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
                                  const FreshProgressBar(
                                    percent: 0.4,
                                    direction: Axis.horizontal,
                                    length: 220 * 1.4 - 12,
                                    thickness: 12,
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      const Text('Mục tiêu hoàn thành'),
                                      Text(
                                        '75%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
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
  }) : super(key: key);

  final Widget image;
  final String title;
  final Color color;
  final bool isCenter;

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

                // shape: BoxShape.circle,
              ),
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
          )
        else
          Transform.translate(
            offset: const Offset(-10, 0),
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
