import 'package:community_material_icon/community_material_icon.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/campaign_detail/controller/campaign_controller.dart';
import 'package:freshme/campaign_detail/utils/custom_md.dart';
import 'package:freshme/fresh_items/fresh_items_dialog.dart';
import 'package:freshme/fresh_widget/dotted_button.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/fresh_widget/fresh_frame.dart';
import 'package:freshme/fresh_widget/fresh_progress_bar.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class CampaignPage extends ConsumerWidget {
  const CampaignPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final campaignAsync = ref.watch(campaignControllerProvider(id));

    final campaign = campaignAsync.mapOrNull(
      (value) => value,
      loading: (_) => null,
      error: (e) => null,
    );
    if (campaign == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CommunityMaterialIcons.arrow_left),
            ),
          ),
          title: Text(
            'Chi tiết chiến dịch',
            style: theme.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(CommunityMaterialIcons.share),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
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
                            'HÀNH TRÌNH ĐỎ BẮC NINH 2022',
                            style: theme.textTheme.titleLarge!.copyWith(
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
                                'THPT Hàn Thuyên',
                                style: theme.textTheme.bodySmall,
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
                          Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SeparatedRow(
                                    separatorBuilder: () => const Gap(8),
                                    children: [
                                      FreshChip(
                                        onPressed: () {},
                                        color: const Color(0xFFB2291F),
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
                              const Gap(4),
                              Row(
                                children: [
                                  const Icon(
                                    CommunityMaterialIcons.map_marker_outline,
                                    size: 18,
                                  ),
                                  const Gap(4),
                                  Text(
                                    'TP Bắc Ninh, Bắc Ninh',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(30),
                          const FreshProgressBar(
                            percent: 0.6,
                            direction: Axis.horizontal,
                            length: double.maxFinite,
                            thickness: 20,
                          ),
                          const Gap(12),
                          const MarkdownBody(
                            data: '''Mục tiêu: 
- 500 lít máu''',
                          ),
                          const Gap(12),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                          const Gap(12),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          MarkdownBody(
                            data: campaign.content,
                            imageDirectory: 'https://raw.githubusercontent.com',
                            imageBuilder: (uri, title, alt) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: AspectRatio(
                                aspectRatio: 1.4,
                                child: FreshFrame(
                                  angle: FreshAngle.balance,
                                  child: Semantics(
                                    tooltip: alt,
                                    attributedLabel:
                                        AttributedString(title ?? ''),
                                    child: Image.network(
                                      'https://raw.githubusercontent.com${uri.path}',
                                      fit: BoxFit.cover,
                                      width: double.maxFinite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTapLink: (text, href, title) {
                              if (href == null) return;
                              final uri = Uri.tryParse(href);
                              if (uri == null) return;
                              launchUrl(uri);
                            },
                            selectable: false,
                            softLineBreak: true,
                            styleSheet: MarkdownStyleSheet(
                              horizontalRuleDecoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1.0,
                                    color: theme.dividerColor,
                                  ),
                                ),
                              ),
                            ),
                            builders: {
                              'crs': CarouselBuilder(),
                            },
                            blockSyntaxes: [
                              CarouselSyntax(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Builder(
                  builder: (_) {
                    return FreshDottedButton(
                      child: const Text('Ủng hộ'),
                      onPressed: () {
                        final md = MediaQuery.of(context);

                        showModalBottomSheet(
                          context: context,
                          anchorPoint: Offset(1, 1),
                          builder: (_) => FreshItemsDialog(context),
                          backgroundColor: Colors.transparent,
                          constraints: const BoxConstraints.expand(height: 500),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
