import 'package:flutter/material.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();

  final List<String> reasons = [
    "لم أعد أستخدم التطبيق.",
    "واجهت مشاكل تقنية.",
    "لم أكن راضيًا عن خدمة العملاء.",
    "وجدت تطبيقًا أفضل."
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          
          const SafeArea(
            child: CustomAppBar(
              title: "حذف الحساب",
              showBackButton: true,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "نحن نأسف لسماع رغبتك في حذف حسابك في سوقنا. نود أن نفهم سبب رغبتك في ذلك حتى نتمكن من تحسين خدماتنا في المستقبل.",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 20),
                   Text(
                    "سبب حذف الحساب",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...reasons
                      .map((reason) => _buildCustomOption(reason, theme))
                      ,
                  const SizedBox(height: 10),
                  _buildOtherReason(),
                  const SizedBox(height: 20),
                   Text(
                    "ملاحظة عند الحذف سيتم:",
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "–فقدان جميع بياناتك الشخصية وطلباتك وسجلات التسوق.\n– عدم القدرة على استخدام التطبيق مرة أخرى.",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.secondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildDeleteButton(theme),
    );
  }

  Widget _buildCustomOption(String reason, ColorScheme theme) {
    bool isSelected = _selectedReason == reason;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = isSelected ? null : reason;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.surface,
          border: Border.all(
            color: theme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(1000),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: theme.primary,
              size: 24,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                reason,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.onSurface,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherReason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "سبب آخر",
          style: context.textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
    
          borderRadius: BorderRadius.circular(32),
          color: context.colorScheme.surface,
          ),
          child: TextField(
            controller: _otherReasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "اكتب هنا",
              hintStyle: TextStyle(
                color: context.colorScheme.secondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: context.colorScheme.outline,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(ColorScheme them) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25, left: 16,right: 16,top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: FillButton(
        color: them.error,
        label: "حذف الحساب",
        onPressed: () {},
      ),
    );
  }
}
