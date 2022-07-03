import 'package:community_material_icon/community_material_icon.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:freshme/campaign_detail/custom_md.dart';
import 'package:freshme/fresh_widget/dotted_button.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/fresh_widget/fresh_frame.dart';
import 'package:gap/gap.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

const _content = '''
🩸 Hành trình Đỏ là Chiến dịch nhân đạo cấp Quốc gia do Ban chỉ đạo Quốc gia vận động hiến máu tình nguyện tổ chức với sự bảo trợ của các cơ quan Bộ, Ngành TW. Nhiệm vụ trọng tâm của chiến dịch là vận động toàn dân tham gia hiến máu nhân đạo và phòng chống căn bệnh tan máu bẩm sinh - Thalassemia. Trải qua 9 mùa tổ chức, Hành trình Đỏ đã thu về nhiều đơn vị máu quý giá vì sự sống người bệnh. Năm nay, Hành trình Đỏ Bắc Ninh sẽ diễn ra vào ngày 7/7/2022! 
🤔 Sau chuỗi ngày chờ đợt, các bạn đã sẵn sàng để “bùng cháy” chưa nhỉ ⁉️ 
🌈 Hành trình Đỏ Bắc Ninh 2022 chính thức sắp diễn ra rồi. Vâng chỉ còn hơn 1 tuần nữa thôi sẽ diễn ra ngày hội hiến máu lớn của Bắc Ninh hoà chung vào bầu không khí “rực đỏ” toàn quốc. Hành trình Đỏ Bắc Ninh với sứ mệnh là nhịp cầu kết nối trái tim với trái tim, người hiến máu với các bệnh nhân cần máu,... chạm đến những giấc mơ. ❤️
🔥 Hãy cùng tham gia hiến máu tại Hành trình Đỏ Bắc Ninh 2022. Đây hứa hẹn sẽ là điểm đến tuyệt vời cho tháng 7 của bạn! 🥳
👉👉👉 Đừng quên theo dõi fanpage của Máu Bắc Ninh để cập nhật nhanh và chính xác thông tin các điểm hiến máu trên địa bàn tỉnh nhé! ^^

___

[[carousel]](https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png,https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png,https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png,https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)

### **HÀNH TRÌNH ĐỎ BẮC NINH 2022**
⏰ Thời gian: 7h30 đến 16h00 ngày 07/7/2022
📍 Địa điểm: Trung tâm Văn hoá - Thể thao Tp. Bắc Ninh (phường Kinh Bắc - Tp. Bắc Ninh - tỉnh Bắc Ninh)
💌 Mọi thắc mắc xin liên hệ:
❣❣❣ Fanpage CLB: CLB thanh niên CTĐ vận động hiến máu tình nguyện tỉnh Bắc Ninh

https://www.facebook.com/CLBThanhNienVanDongHienMauTinhN.../

☎️☎️☎️ Hotline: 
❣ Chủ nhiệm: Mrs. Trang - 0974 886 447
❣ Phó Chủ nhiệm: Mr. Trà - 0334 751 900''';

const _ct =
    '''[[carousel]](https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png,https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png,https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png,https://raw.githubusercontent.com/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)''';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
          style:
              theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
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
      body: CustomScrollView(
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
                    'Chương trình tình nguyện "Máu đỏ 2022"',
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
                        'CLB Máu - trường ĐH Hà Nội',
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
                  SizedBox(
                    height: 30,
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
                  const Gap(12),
                  const Divider(height: 1),
                  const Gap(6),
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
                    data: _ct,
                    imageDirectory: 'https://raw.githubusercontent.com',
                    imageBuilder: (uri, title, alt) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: AspectRatio(
                        aspectRatio: 1.4,
                        child: FreshFrame(
                          angle: FreshAngle.balance,
                          child: Semantics(
                            tooltip: alt,
                            attributedLabel: AttributedString(title ?? ''),
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
                    selectable: true,
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
                  const Gap(20),
                  SafeArea(
                    top: false,
                    child: FreshDottedButton(
                      child: const Text('Ủng hộ'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
