import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/campaign_detail/controller/campaign_controller.dart';
import 'package:freshme/campaign_detail/utils/custom_md.dart';
import 'package:freshme/campaign_detail/widgets/campaign_header.dart';
import 'package:freshme/campaign_detail/widgets/donation_items_dialog.dart';
import 'package:freshme/_internal/presentation/fresh_dotted_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CampaignPage extends ConsumerStatefulWidget {
  const CampaignPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends ConsumerState<CampaignPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final campaignFuture = ref.watch(campaignControllerProvider(widget.id));

    final campaign = campaignFuture.mapOrNull(
      data: (value) => value.value,
      loading: (_) => null,
      error: (e) => null,
    );
    if (campaign == null) {
      return const Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
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
          style: theme //
              .textTheme
              .bodyLarge!
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
                CampaignHeader(campaign),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        MarkdownBody(
                          data: campaign.content,
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
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => DonationItemsDialog(
                          context,
                          campaignId: widget.id,
                        ),
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
    );
  }
}
