import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/domain/campaign/donate_campaign.dart';

final _fakeCampaignDatabaseProvider =
    Provider<_FakeCampaignDatabase>((ref) => _FakeCampaignDatabase());

class _FakeCampaignDatabase {
  final List<DonateCampaign> _items = [];

  List<DonateCampaign> get items => _items;
}

abstract class CampaignFacade {
  Future<List<DonateCampaign>> getCampaigns();
}

final donationItemServerProvider =
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
}
