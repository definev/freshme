import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/domain/donation/donation_item_group.dart';

final _fakeDonationItemGroupDatabaseProvider =
    Provider<_FakeDonationItemDatabase>((ref) => _FakeDonationItemDatabase());

class _FakeDonationItemDatabase {
  final List<DonationItemGroup> _items = [];

  List<DonationItemGroup> get items => _items;

  void removeItem(String groupId, String itemId) {
    _items
        .firstWhere((group) => group.id == groupId)
        .items
        .removeWhere((item) => item.id == itemId);
  }

  void addItem(String groupId, DonationItem item) {
    _items //
        .firstWhere((group) => group.id == groupId)
        .items
        .add(item);
  }

  void addGroup(DonationItemGroup group) {
    _items.add(group);
  }

  void removeGroup(String groupId) {
    _items.removeWhere((group) => group.id == groupId);
  }
}

abstract class DonationItemFacade {
  Future<void> submitDonationGroup(DonationItemGroup group);

  Future<void> updateDonationItem(String groupId, DonationItem item);

  Future<DonationItemGroup> getDonationGroup(String groupId);

  Future<List<DonationItemGroup>> getDonationGroups();
}

final donationItemServerProvider =
    Provider<DonationItemFacade>((ref) => FakeDonationItemServer(ref));

class FakeDonationItemServer implements DonationItemFacade {
  const FakeDonationItemServer(this.ref);

  final ProviderRef ref;

  _FakeDonationItemDatabase get _database =>
      ref.read(_fakeDonationItemGroupDatabaseProvider);

  @override
  Future<void> submitDonationGroup(DonationItemGroup group) async {
    _database.addGroup(group);
  }

  @override
  Future<void> updateDonationItem(String groupId, DonationItem item) async {
    _database.addItem(groupId, item);
  }

  @override
  Future<DonationItemGroup> getDonationGroup(String groupId) async {
    return _database.items.firstWhere((group) => group.id == groupId);
  }

  @override
  Future<List<DonationItemGroup>> getDonationGroups() async {
    return _database.items;
  }
}
