import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';

// List of FAQs
final List<Map<String, String>> faqs = [
  {
    "question": "كيف يمكنني إنشاء حساب على تطبيق توصيل؟",
    "answer":
        "لإنشاء حساب على تطبيق أكسير، افتح التطبيق، واضغط على زر 'تسجيل' في الصفحة الرئيسية، ثم قم بإدخال بريدك الإلكتروني وكلمة المرور المطلوبة، واتبع التعليمات حتى إكمال عملية التسجيل."
  },
  {
    "question": "كيف يمكنني تتبع طلب بعد الشراء؟",
    "answer": "يمكنك تتبع طلبك من خلال قسم الطلبات داخل التطبيق."
  },
  {
    "question": "ما هي طرق الدفع المتاحة في تطبيق أكسير؟",
    "answer":
        "نوفر الدفع عن طريق البطاقة الائتمانية، باي بال، والدفع عند الاستلام."
  },
  {
    "question": "هل يمكنني إرجاع المنتجات التي اشتريتها؟",
    "answer": "نعم، يمكنك إرجاع المنتجات خلال 14 يومًا من تاريخ الاستلام."
  },
  {
    "question": "كيف يمكنني تعديل عنوان التوصيل الخاص بي؟",
    "answer": "يمكنك تعديل عنوان التوصيل من خلال قسم العناوين في حسابك الشخصي."
  },
];

class CommonQuestionsScreen extends StatefulWidget {
  const CommonQuestionsScreen({super.key});

  @override
  State<CommonQuestionsScreen> createState() => _CommonQuestionsScreenState();
}

class _CommonQuestionsScreenState extends State<CommonQuestionsScreen> {
  Set<int> expandedTiles = {}; // Store indices of expanded tiles

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFFBFAFF),
          child: Column(
            children: [
              const CustomAppBar(
                title: "الأسئلة الشائعة",
                showBackButton: true,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: buildCard(
                        faqs[index]["question"]!,
                        faqs[index]["answer"]!,
                        index,
                        theme,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildCard(String question, String answer, int index, theme) {
    bool isExpanded = expandedTiles.contains(index); // Check if expanded

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(isExpanded ? 16 : 64), // Dynamic radius
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(isExpanded ? 16 : 64), // Apply here too
          side: const BorderSide(width: 1, color: Color(0xFFF1F2F4)),
        ),
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent, // Remove splash effect
            highlightColor: Colors.transparent, // Remove highlight effect
          ),
          child: ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: "Tajawal",
                color: Color(0xFF121416),
              ),
              textAlign: TextAlign.right,
            ),
            trailing: SvgPicture.asset(
              "assets/svg/downrowsvg.svg",
              color: theme.colorScheme.primary,
            ),
            onExpansionChanged: (expanded) {
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  if (expanded) {
                    expandedTiles.add(index); // Add to expanded set
                  } else {
                    expandedTiles.remove(index); // Remove when collapsed
                  }
                });
              });
            },
            children: [
              Container(
                height: 1,
                color: const Color(0xFFF1F2F4),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16), // Keep rounded bottom
                  ),
                ),
                child: Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF70798F),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
