import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/_internal/presentation/fresh_dotted_button.dart';
import 'package:freshme/register/widgets/register_section.dart';
import 'package:gap/gap.dart';

class SplashSection extends ConsumerWidget {
  const SplashSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaddedColumn(
      padding: const EdgeInsets.all(20),
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Text(
                'Bắt đầu thay đổi thế giới\nngay từ hôm nay',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ) //
                  .animate()
                  .fade(duration: 500.ms),
              const Gap(20),
              const Text(
                'Hãy ủng hộ FRESHME, cung cấp những vật dụng cũ mà bạn không sử dụng, sứ mệnh của FRESHME sẽ là đưa nó đến những người thực sự cần. Mọi đóng góp của bạn có thể góp phần giúp đỡ trẻ em nghèo và gia đình của các em có được sự bảo vệ, chăm sóc sức khỏe và giáo dục quan trọng.',
                textAlign: TextAlign.center,
              ) //
                  .animate()
                  .fade(duration: 500.ms),
            ],
          ),
        ),
        const Gap(20),
        Center(
          child: SizedBox(
            width: 200,
            child: FreshDottedButton(
              radius: 15,
              onPressed: () => ref
                  .read(registerSectionProvider.notifier)
                  .state = RegisterSectionState.signUp,
              child: const Text('Signup Now'),
            ),
          ) //
              .animate()
              .fade(duration: 500.ms),
        ),
      ],
    );
  }
}
