import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/domain/donation_item_group.dart';

final mockDonationItemClientProvider =
    Provider<MockDonationItemClient>((ref) => MockDonationItemClient());

class MockDonationItemClient {
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
