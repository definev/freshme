import 'package:camera/camera.dart';
import 'package:dartx/dartx.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freshme/_internal/domain/donation/donation_item_group.dart';
import 'package:freshme/_internal/presentation/fresh_loading_indicator.dart';
import 'package:freshme/backend_simulator/donation_item_server.dart';
import 'package:freshme/camera/controller/fresh_ml_controller.dart';
import 'package:freshme/camera/widgets/image_selector.dart';
import 'package:freshme/camera/widgets/self_classification_sheet.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

final freshMLControllerProvider = Provider<FreshMLController>(
  (ref) => throw UnimplementedError(),
);

class ImageProcessingSheet extends HookConsumerWidget {
  const ImageProcessingSheet(this.imageFile, {super.key});

  final XFile imageFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(freshMLControllerProvider);
    final resultFuture = useFuture(controller.processImageFromXFile(imageFile));

    if (resultFuture.hasData) {
      return _ImageProcessingSheetResult(imageFile, result: resultFuture.data!);
    }
    return const FreshLoadingIndicator();
  }
}

class _ImageProcessingSheetResult extends ConsumerStatefulWidget {
  const _ImageProcessingSheetResult(
    this.imageFile, {
    required this.result,
  });

  final XFile imageFile;
  final FreshMLImageResult result;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImageProcessingSheetState();
}

class _ImageProcessingSheetState
    extends ConsumerState<_ImageProcessingSheetResult> {
  late PageController pageController;

  late Size _imageAbsoluteSize;

  List<Rect> _rects = [];
  List<String> _labels = [];
  List<bool> _selectedList = [];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    initializeMLResult();
  }

  void initializeMLResult() async {
    final result = widget.result;
    _imageAbsoluteSize = result.absoluteSize;
    _rects = result.objects
        .map(
          (e) => Rect.fromLTRB(
            e.boundingBox.left / result.absoluteSize.width,
            e.boundingBox.top / result.absoluteSize.height,
            e.boundingBox.right / result.absoluteSize.width,
            e.boundingBox.bottom / result.absoluteSize.height,
          ),
        )
        .toList();
    _labels = result.objects
        .map(
          (e) => e.labels.isEmpty
              ? ''
              : e.labels
                  .reduce((value, element) =>
                      value.confidence > element.confidence //
                          ? value
                          : element)
                  .text,
        )
        .toList();
    _selectedList = List.generate(
      _rects.length,
      (index) => true,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_selectedList.isEmpty) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Phân loại ảnh'),
          centerTitle: true,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Phân loại ảnh'),
        centerTitle: true,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: _imageAbsoluteSize.width / _imageAbsoluteSize.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  itemCount: _rects.length,
                  itemBuilder: (context, index) {
                    final rect = _rects[index];
                    final label = _labels[index];
                    final selected = _selectedList[index];

                    return _MLResultPreview(
                      imagePath: widget.imageFile.path,
                      rect: rect,
                      label: label,
                      selected: selected,
                      onRectChanged: (value) => _rects[index] = value,
                      onLabelChanged: (value) => _labels[index] = value,
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (currentPage == _rects.length - 1)
                      FloatingActionButton.extended(
                        onPressed: () async {
                          const uuid = Uuid();
                          final indexList = _selectedList
                              .mapIndexedNotNull((index, selected) //
                                  =>
                                  selected ? index : null);
                          final navigator = Navigator.of(context);

                          try {
                            await ref
                                .watch(donationItemServerProvider)
                                .submitDonationGroup(
                                  DonationItemGroup(
                                    id: uuid.v4(),
                                    imageUrl: widget.imageFile.path,
                                    items: indexList.map<DonationItem>(
                                      (index) {
                                        final rect = _rects[index];
                                        final label = _labels[index];

                                        return DonationItem(
                                          id: uuid.v4(),
                                          name: label,
                                          boundingBox: rect,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                );
                            navigator.pop(true);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Xác nhận'),
                      ),
                    PaddedRow(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (pageController.page == 0) return;
                            currentPage = (pageController.page! - 1).toInt();
                            pageController.previousPage(
                              duration: 200.milliseconds,
                              curve: Curves.decelerate,
                            );
                            await Future.delayed(200.milliseconds);
                            if (mounted) setState(() {});
                          },
                          child: const Icon(Icons.chevron_left_rounded),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _selectedList[currentPage]
                                ? ElevatedButton(
                                    key: ValueKey(
                                        'select_button : $currentPage'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.error,
                                    ),
                                    onPressed: () {
                                      _selectedList[currentPage] =
                                          !_selectedList[currentPage];
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Loại bỏ',
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              color: theme.colorScheme.onError),
                                    ),
                                  )
                                : ElevatedButton(
                                    key: ValueKey(
                                        'select_button : $currentPage'),
                                    onPressed: () {
                                      _selectedList[currentPage] =
                                          !_selectedList[currentPage];
                                      setState(() {});
                                    },
                                    child: const Text('Xác nhận'),
                                  ),
                            if (currentPage == _rects.length - 1) ...[
                              const Gap(12),
                              ElevatedButton(
                                onPressed: () async {
                                  final res =
                                      await SelfClassificationSheet.show(
                                    context,
                                    imagePath: widget.imageFile.path,
                                    aspectRatio: _imageAbsoluteSize.width /
                                        _imageAbsoluteSize.height,
                                  );

                                  if (res != null) {
                                    _rects.add(res.rect);
                                    _labels.add(res.label);
                                    _selectedList.add(true);
                                    setState(() {});
                                  }
                                },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (pageController.page == _rects.length - 1) {
                              return;
                            }

                            currentPage = (pageController.page! + 1).toInt();
                            pageController.nextPage(
                              duration: 200.milliseconds,
                              curve: Curves.decelerate,
                            );
                            await Future.delayed(200.milliseconds);
                            if (mounted) setState(() {});
                          },
                          child: const Icon(Icons.chevron_right_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MLResultPreview extends StatelessWidget {
  const _MLResultPreview({
    required this.rect,
    required this.label,
    required this.imagePath,
    required this.selected,
    required this.onRectChanged,
    required this.onLabelChanged,
  });

  final Rect rect;
  final String label;
  final String imagePath;
  final bool selected;
  final ValueChanged<Rect> onRectChanged;
  final ValueChanged<String> onLabelChanged;

  @override
  Widget build(BuildContext context) {
    final topLeft = rect.topLeft;
    final bottomRight = rect.bottomRight;
    final theme = Theme.of(context);

    return Stack(
      children: [
        ImageSelector(
          imagePath,
          initStartOffset: topLeft,
          initEndOffset: bottomRight,
          onStartOffsetChanged: (value) => Rect.fromPoints(
            value,
            rect.bottomRight,
          ),
          onEndOffsetChanged: (value) => Rect.fromPoints(
            rect.topLeft,
            value,
          ),
        ),
        SizedBox(
          height: 56,
          width: double.maxFinite,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: HookBuilder(
                builder: (context) {
                  final controller = useTextEditingController(
                    text: label.isBlank ? 'Không rõ' : label,
                  );
                  final focusNode = useFocusNode();

                  return EditableText(
                    controller: controller,
                    focusNode: focusNode,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge!,
                    cursorColor: theme.colorScheme.primary,
                    backgroundCursorColor: Colors.transparent,
                    onChanged: onLabelChanged,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
