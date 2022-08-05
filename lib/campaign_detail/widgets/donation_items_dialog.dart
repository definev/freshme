import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/num_duration_extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freshme/campaign_detail/controller/campaign_controller.dart';
import 'package:freshme/_internal/domain/campaign/single_target.dart';
import 'package:freshme/_internal/presentation/fresh_dotted_button.dart';
import 'package:freshme/_internal/presentation/fresh_snack_bar.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dartx/dartx.dart';

final _errorMessageProvider = StateProvider.autoDispose<String?>((_) => null);
final _targetUnitsProvider =
    StateProvider.autoDispose.family<List<TargetUnit>, String>(
  (ref, campaignId) {
    final campaignDetails = ref.watch(campaignControllerProvider(campaignId));
    final data = campaignDetails.mapOrNull(data: (data) => data.value);
    if (data == null) return [];

    return data //
        .target
        .list
        .where(
          (t) => t.map(
            exact: (exact) => exact.currentValue < exact.goal,
            minimum: (minimum) => true,
            between: (between) => between.currentValue <= between.lessThan,
          ),
        )
        .map(
          (t) => TargetUnit(
            t.detail,
            unit: 0,
            limit: t.limitNeeded,
          ),
        )
        .toList();
  },
);

extension on List<TargetUnit> {
  bool get canSubmit {
    return fold(false, (prev, target) {
      if (prev) return true;
      return target.unit > 0;
    });
  }
}

class DonationItemsDialog extends HookConsumerWidget {
  const DonationItemsDialog(
    this.prevContext, {
    super.key,
    required this.campaignId,
  });

  final BuildContext prevContext;
  final String campaignId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMounted = useIsMounted();

    ref.listen<String?>(
      _errorMessageProvider,
      (previous, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            FreshSnackBar.getSnackBar(
              title: Text.rich(
                TextSpan(
                  children: next //
                      .split(':')
                      .mapIndexed(
                        (index, text) => TextSpan(
                          text: index == 0 ? '$text:' : text,
                          style: theme //
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: index == 0 ? FontWeight.bold : null,
                            decoration:
                                index == 0 ? TextDecoration.underline : null,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 62),
            ),
          );
          Future.delayed(
            1200.ms,
            () {
              if (!isMounted()) return;
              ScaffoldMessenger.of(context).clearSnackBars();
              ref.read(_errorMessageProvider.notifier).state = null;
            },
          );
        }
      },
    );

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: ColoredBox(
          color: theme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Ủng hộ',
                  style: theme //
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(20),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: 400.ms,
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      child: TargetUnitListView(campaignId),
                    ),
                  ),
                ),
                const Gap(30),
                BottomButtons(campaignId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomButtons extends ConsumerWidget {
  const BottomButtons(
    this.campaignId, {
    Key? key,
  }) : super(key: key);

  final String campaignId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final md = MediaQuery.of(context);
    final canSubmit = ref.watch(
      _targetUnitsProvider(campaignId).select((value) {
        return value.canSubmit;
      }),
    );

    return Row(
      children: [
        AnimatedSize(
          duration: 400.ms,
          clipBehavior: Clip.none,
          curve: Curves.ease,
          child: SizedBox(
            width: canSubmit
                ? (md.size.width - 32 - 10) * 0.5
                : md.size.width - 32,
            child: FreshDottedButton(
              outterColor: theme.colorScheme.error,
              innerColor: theme.colorScheme.error,
              outterBordered: false,
              child: Text(
                'Hủy',
                style: theme //
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: theme.colorScheme.error),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        AnimatedSize(
          duration: 400.ms,
          clipBehavior: Clip.none,
          curve: Curves.ease,
          child: Padding(
            padding:
                !canSubmit ? EdgeInsets.zero : const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: canSubmit ? (md.size.width - 32 - 10) * 0.5 : 0,
              child: FreshDottedButton(
                outterColor: theme.colorScheme.primary,
                innerColor: theme.colorScheme.primary,
                outterBordered: false,
                child: const Text('Xác nhận'),
                // TODO(definev): open check screen, and push data to server
                // Set state of donation order to 'processing'
                // Organization contact back to user to confirm the donation
                // if they are not sure, they can cancel the donation
                // if they are sure, they can confirm the donation, set the state to 'completed'
                // if state is 'completed', update the campaign's target unit
                // When organization receives donation, set state to 'done'
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TargetUnitListView extends HookConsumerWidget {
  const TargetUnitListView(this.campaignId, {super.key});

  final String campaignId;

  bool _setNewTargetValue(WidgetRef ref, int index, int unit) {
    if (unit < 0) return false;
    final targetUnitsNotifier =
        ref.watch(_targetUnitsProvider(campaignId).notifier);

    var newValue = targetUnitsNotifier.state;
    newValue[index] = newValue[index].copyWith(unit: unit);
    targetUnitsNotifier.state = List.from(newValue);
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetUnits = ref.watch(_targetUnitsProvider(campaignId));

    return ListView.builder(
      itemBuilder: (context, index) {
        return HookBuilder(
          builder: (context) {
            final textController = useTextEditingController(text: '0');

            return ListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              title: Text(targetUnits[index].detail.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      final valid = _checkValidUnit(
                        ref,
                        targetUnits[index],
                        targetUnits[index].unit - 1,
                      );
                      if (valid == false) return;

                      _updateUnitText(
                        index,
                        ref: ref,
                        textController: textController,
                        unit: targetUnits[index].unit - 1,
                      );
                    },
                    child: const Icon(Icons.exposure_minus_1),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: 48,
                    child: CupertinoTextField(
                      controller: textController,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*$'),
                        ),
                        if (targetUnits[index].limit != null)
                          ValueLimitingTextInputFormatter(
                            targetUnits[index].limit!,
                            ref,
                          ),
                      ],
                      onChanged: (value) {
                        final unit = int.tryParse(value);
                        if (unit == null) return;
                        _setNewTargetValue(ref, index, unit);
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Gap(4),
                  TextButton(
                    onPressed: () {
                      final valid = _checkValidUnit(
                        ref,
                        targetUnits[index],
                        targetUnits[index].unit + 1,
                      );
                      if (valid == false) return;

                      _updateUnitText(
                        index,
                        ref: ref,
                        textController: textController,
                        unit: targetUnits[index].unit + 1,
                      );
                    },
                    child: const Icon(Icons.exposure_plus_1),
                  ),
                ],
              ),
            );
          },
        );
      },
      itemCount: targetUnits.length,
    );
  }

  void _updateUnitText(
    int index, {
    required WidgetRef ref,
    required TextEditingController textController,
    required int unit,
  }) {
    final setted = _setNewTargetValue(ref, index, unit);
    if (setted == false) return;
    textController.text = unit.toString();
  }

  bool _checkValidUnit(WidgetRef ref, TargetUnit targetUnit, int newUnit) {
    final limit = targetUnit.limit;
    if (newUnit < 0) {
      ref.read(_errorMessageProvider.notifier).state =
          '${targetUnit.detail.name}: Số lượng phải lớn hơn 0';
      return false;
    }
    if (limit == null) return true;
    if (newUnit > limit) {
      ref.read(_errorMessageProvider.notifier).state =
          '${targetUnit.detail.name}: Vượt quá giới hạn';
      return false;
    }

    return true;
  }
}

class ValueLimitingTextInputFormatter extends TextInputFormatter {
  ValueLimitingTextInputFormatter(this.limit, this.ref);
  final int limit;
  final WidgetRef ref;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    int value = int.tryParse(newValue.text) ?? int.tryParse(oldValue.text) ?? 0;
    if (value > limit) {
      ref.read(_errorMessageProvider.notifier).state = 'Vượt quá giới hạn';
      return oldValue;
    }
    return newValue;
  }
}
