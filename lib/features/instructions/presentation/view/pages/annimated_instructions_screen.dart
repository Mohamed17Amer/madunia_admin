import 'dart:async';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';

class AnimatedInstructionsScreen extends StatefulWidget {
  const AnimatedInstructionsScreen({super.key});

  @override
  State<AnimatedInstructionsScreen> createState() =>
      _AnimatedInstructionsScreenState();
}

class _AnimatedInstructionsScreenState
    extends State<AnimatedInstructionsScreen> {
  final ScrollController _scrollController =
      ScrollController(); // control duration
  late Timer _timer;

  double scrollSpeed = 1.0;

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0); // Restart from top
        } else {
          _scrollController.jumpTo(currentScroll + scrollSpeed);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: instructions.length + 2,
      separatorBuilder: (context, index) => const Divider(
        height: 2.0,
        indent: 2.0,
        color: AppColors.bottomNavBarSelectedItemColor,
      ),
      itemBuilder: (context, index) {
        if (index == 0 || index == instructions.length + 1) {
          return const SizedBox(height: 800); // Top & bottom padding
        }

        final realIndex = index - 1;
        return ListTile(
          leading: CircleAvatar(child: Text("${realIndex + 1}")),
          title: Center(
            child: Text(
              instructions[realIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  final instructions = [
    "يُطلب اسم المستخدم وكلمة المرور من الأدمن مُباشرةً",
    "يتم إمهال فترة لتحويل الإيجار من يوم 1 إلى يوم 4 من كل شهر.",

    "يتم تسليم الإيجار لصاحب السكن يوم 5 من كل شهر.",
    "عدم التأخير في سداد فواتير الكهرباء والتليفون الأرضي والإنترنت.",
    "يتم إخبار الأدمن مباشرة مع كل تجديد لباقة الإنترنت لمن يُريد الإشتراك، وإلا سيتم فصل جهازه عن الشبكة بشكل تلقائي.",
    "يتم تحويل أي مبلغ مستحق على نفس رقم الأدمن والمذكور في البند التالي",
    "+"
        "201011245647",
    " يتم التحويل عن طريق إنستاباي أو فودافون كاش فقط",
    "يتم إرسال سكرين التحويل على الواتس للأدمن",
  ];
}
