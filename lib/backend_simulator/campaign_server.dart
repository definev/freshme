import 'package:dartx/dartx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/domain/campaign/donate_campaign.dart';

import 'dart:ui';

import 'package:freshme/_internal/domain/campaign/campaign_target.dart';
import 'package:freshme/_internal/domain/campaign/donate_category.dart';
import 'package:freshme/_internal/domain/campaign/personal_donate.dart';
import 'package:freshme/_internal/domain/campaign/single_target.dart';

const _content = '''
🩸 Hành trình Đỏ là Chiến dịch nhân đạo cấp Quốc gia do Ban chỉ đạo Quốc gia vận động hiến máu tình nguyện tổ chức với sự bảo trợ của các cơ quan Bộ, Ngành TW. Nhiệm vụ trọng tâm của chiến dịch là vận động toàn dân tham gia hiến máu nhân đạo và phòng chống căn bệnh tan máu bẩm sinh - Thalassemia. Trải qua 9 mùa tổ chức, Hành trình Đỏ đã thu về nhiều đơn vị máu quý giá vì sự sống người bệnh. Năm nay, Hành trình Đỏ Bắc Ninh sẽ diễn ra vào ngày 7/7/2022! 
🤔 Sau chuỗi ngày chờ đợt, các bạn đã sẵn sàng để “bùng cháy” chưa nhỉ ⁉️ 
🌈 Hành trình Đỏ Bắc Ninh 2022 chính thức sắp diễn ra rồi. Vâng chỉ còn hơn 1 tuần nữa thôi sẽ diễn ra ngày hội hiến máu lớn của Bắc Ninh hoà chung vào bầu không khí “rực đỏ” toàn quốc. Hành trình Đỏ Bắc Ninh với sứ mệnh là nhịp cầu kết nối trái tim với trái tim, người hiến máu với các bệnh nhân cần máu,... chạm đến những giấc mơ. ❤️
🔥 Hãy cùng tham gia hiến máu tại Hành trình Đỏ Bắc Ninh 2022. Đây hứa hẹn sẽ là điểm đến tuyệt vời cho tháng 7 của bạn! 🥳
👉👉👉 Đừng quên theo dõi fanpage của Máu Bắc Ninh để cập nhật nhanh và chính xác thông tin các điểm hiến máu trên địa bàn tỉnh nhé! ^^

[[carousel]](https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg,https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg,https://www.w3schools.com/w3css/img_forest.jpg)
### **HÀNH TRÌNH ĐỎ BẮC NINH 2022**
⏰ Thời gian: 7h30 đến 16h00 ngày 07/7/2022
📍 Địa điểm: Trung tâm Văn hoá - Thể thao Tp. Bắc Ninh (phường Kinh Bắc - Tp. Bắc Ninh - tỉnh Bắc Ninh)
💌 Mọi thắc mắc xin liên hệ:
❣❣❣ Fanpage CLB: CLB thanh niên CTĐ vận động hiến máu tình nguyện tỉnh Bắc Ninh

https://www.facebook.com/CLBThanhNienVanDongHienMauTinhN.../

☎️☎️☎️ Hotline: 
❣ Chủ nhiệm: Mrs. Trang - 0974 886 447
❣ Phó Chủ nhiệm: Mr. Trà - 0334 751 900''';

const _defaultCampaign = DonateCampaign(
  id: '0',
  name: 'HÀNH TRÌNH ĐỎ BẮC NINH 2022',
  thumbnails: [
    'http://chungtadidau.com/wp-content/uploads/2016/07/quyen-gop-sach-giao-khoa-cho-tre-em-vung-cao-576.jpg',
  ],
  orgId: '123',
  location: 'TP. Bắc Ninh - Tỉnh Bắc Ninh',
  content: _content,
  categories: [
    DonateCategory(
      '0',
      name: 'Sức khỏe',
      color: Color(0xFFB2291F),
    ),
  ],
  target: CampaignTarget([
    SingleTarget.between(
      detail: TargetDetail(
        resource: TargetResource.people,
        name: 'Tình nguyện viên',
        unit: 'người',
      ),
      lessThan: 10,
      greaterThan: 5,
    ),
    SingleTarget.minimum(
      detail: TargetDetail(
        resource: TargetResource.item,
        name: 'Quần',
        unit: 'chiếc',
      ),
      goal: 20,
    ),
    SingleTarget.exact(
      detail: TargetDetail(
        resource: TargetResource.item,
        name: 'Đồ chơi trẻ em',
        unit: 'chiếc',
      ),
      goal: 30,
    ),
  ]),
);

final _fakeCampaignDatabaseProvider =
    Provider<_FakeCampaignDatabase>((ref) => _FakeCampaignDatabase());

class _FakeCampaignDatabase {
  final List<DonateCampaign> _items = [_defaultCampaign];

  List<DonateCampaign> get items => _items;
}

abstract class CampaignFacade {
  Future<DonateCampaign> getCampaign(String campaignId);

  Future<List<DonateCampaign>> getCampaignsByPage(int page, int amount);

  Future<List<DonateCampaign>> getCampaigns();

  Future<int> getCampaignsCount();
}

final campaignServerProvider =
    Provider<CampaignFacade>((ref) => FakeCampaignServer(ref));

class FakeCampaignServer implements CampaignFacade {
  const FakeCampaignServer(this.ref);

  final ProviderRef ref;

  _FakeCampaignDatabase get _database =>
      ref.read(_fakeCampaignDatabaseProvider);

  @override
  Future<List<DonateCampaign>> getCampaigns() {
    return Future.value(_database.items);
  }

  @override
  Future<List<DonateCampaign>> getCampaignsByPage(int page, int amount) async {
    final start = page * amount;
    var end = (page + 1) * amount - 1;

    if (end > _database._items.length) {
      end = _database._items.length;
    }

    return _database._items.sublist(start, end);
  }

  @override
  Future<int> getCampaignsCount() async {
    return Future.value(_database._items.length);
  }

  @override
  Future<DonateCampaign> getCampaign(String campaignId) async {
    await Future.delayed(1.seconds);
    return Future.value(
      _database._items.where((element) => element.id == campaignId).firstOrNull,
    );
  }
}
