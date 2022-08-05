import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/domain/donation/donation_item_group.dart';
import 'package:freshme/_internal/presentation/fresh_loading_indicator.dart';
import 'package:freshme/backend_simulator/donation_item_server.dart';

final donationItemsProvider =
    FutureProvider.autoDispose<List<DonationItemGroup>>((ref) {
  final server = ref.watch(donationItemServerProvider);
  return server.getDonationGroups();
  ;
});

class DonationItemsPage extends ConsumerWidget {
  const DonationItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(donationItemsProvider);

    return Scaffold(
      body: data.map(
        data: (data) {
          final donationItemsGroup = data.value;

          return ListView.builder(
            itemCount: donationItemsGroup.length,
            itemBuilder: (context, index) {
              final data = donationItemsGroup[index];

              return Card(
                child: Column(
                  children: [
                    Image.file(File(data.imageUrl)),
                  ],
                ),
              );
            },
          );
        },
        error: (e) => Center(child: Text(e.toString())),
        loading: (_) => const FreshLoadingIndicator(),
      ),
    );
  }
}
