import 'package:community_material_icon/community_material_icon.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:freshme/_internal/domain/campaign/single_target.dart';
import 'package:gap/gap.dart';

class CampaignTargetWidget extends StatelessWidget {
  const CampaignTargetWidget(this.target, {super.key});

  final SingleTarget target;

  Widget _buildCurrentGoal(BuildContext context) {
    final theme = Theme.of(context);

    return target.map(
      exact: (exact) {
        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _CompareTile(
                icon: CommunityMaterialIcons.equal,
                title: '${exact.goal} ${exact.detail.unit}',
              ),
              Divider(
                height: 16,
                color: theme.colorScheme.onBackground,
              ),
              Text('${exact.currentValue} ${exact.detail.unit}'),
            ],
          ),
        );
      },
      minimum: (minimum) {
        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _CompareTile(
                icon: CommunityMaterialIcons.greater_than_or_equal,
                title: '${minimum.goal} ${minimum.detail.unit}',
              ),
              Divider(
                height: 16,
                color: theme.colorScheme.onBackground,
              ),
              Text('${minimum.currentValue} ${minimum.detail.unit}'),
            ],
          ),
        );
      },
      between: (between) => IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _CompareTile(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              icon: CommunityMaterialIcons.greater_than_or_equal,
              title: '${between.greaterThan} ${between.detail.unit}',
            ),
            const Gap(8),
            _CompareTile(
              icon: CommunityMaterialIcons.less_than_or_equal,
              title: '${between.lessThan} ${between.detail.unit}',
            ),
            Divider(color: theme.colorScheme.onBackground),
            Padding(
              padding: const EdgeInsets.only(right: 0.6),
              child: Text('${between.currentValue} ${between.detail.unit}'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(target.detail.name),
      children: [
        const Divider(height: 1, thickness: 2),
        Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PaddedColumn(
                  padding: const EdgeInsets.only(left: 20),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mục tiêu',
                      style: theme //
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(16),
                    Text(
                      'Đã đạt',
                      style: theme //
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                _buildCurrentGoal(context),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _CompareTile extends StatelessWidget {
  const _CompareTile({
    Key? key,
    required this.icon,
    required this.title,
    this.mainAxisAlignment = MainAxisAlignment.end,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Icon(icon, size: 18),
        const Gap(4),
        Text(title),
      ],
    );
  }
}
