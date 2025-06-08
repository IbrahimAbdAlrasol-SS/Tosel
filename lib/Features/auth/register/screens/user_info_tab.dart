import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:flutter/material.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoTab extends StatefulWidget {
  const UserInfoTab({super.key});

  @override
  State<UserInfoTab> createState() => _UserInfoTabState();
}

class _UserInfoTabState extends State<UserInfoTab> {
  XFile? pickedFile;


  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    String? imagePath = "";

    // لفتح معرض الصور واختيار صورة واحدة
    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      //
      setState(() {
        imagePath = pickedFile?.name;
      });
    } else {
      imagePath = ""; // لا يوجد صورة
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpaces.allMedium,
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          CustomTextFormField(
            label: "أسم صاحب المتجر",
            hint: "مثال: \"محمد حسين\"",
            prefixInner: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("assets/svg/User.svg",
              width: 24,
              height: 24,
              color: Theme.of(context).colorScheme.primary,
              ),
            ),
            //validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
          ),
          const Gap(AppSpaces.medium),
           CustomTextFormField(
            label: "اسم المتجر",
            hint: "مثال: \"معرض الأخوين\"",
            keyboardType: TextInputType.text,
            prefixInner: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("assets/svg/12. Storefront.svg",
              color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
          ),
          const Gap(AppSpaces.medium),
           CustomTextFormField(
            label: "رقم هاتف المتجر",
            hint: "07xx Xxx Xxx",
            keyboardType: TextInputType.phone,
            prefixInner: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("assets/svg/08. Phone.svg",
              color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Gap(AppSpaces.medium),
          CustomTextFormField(
            initialValueText: pickedFile?.path,
            readOnly: true,
            label: "شعار / صورة المتجر",
            hint: "أضغط هنا",
            validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
            suffixInner: GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 115,
                height: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(27),
                    bottomLeft: Radius.circular(27),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "تحميل الصورة",
                    style: TextStyle(
                      color: Color(0XFFFAFEFD),
                      fontSize: 16,
                      fontFamily: "Tajawal",
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(AppSpaces.medium),
           CustomTextFormField(
            label: "الرمز السري",
             prefixInner: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("assets/svg/09. Password.svg",
              color: Theme.of(context).colorScheme.primary,
              ),
              
            ),
            suffixInner:Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("assets/svg/10. EyeSlash.svg",
              ),
            ),
          
          ),
          const Gap(AppSpaces.medium),
          CustomTextFormField(
            label: "تأكيد الرمز السري",
            validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
            prefixInner: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("assets/svg/09. Password.svg",
              color: Theme.of(context).colorScheme.primary,
              ),
            ),
            suffixInner:Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset("assets/svg/10. EyeSlash.svg",
              ),
            ),
          ), 
          const Gap(30),
          Container(
            alignment: Alignment.bottomLeft,
            decoration: const BoxDecoration(),
            child: FillButton(
              label: "التالي",
              width: 150,
              height: 50,
              onPressed: () {},
            ),
          ),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "هل لديك حساب؟",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const Gap(AppSpaces.exSmall),
              GestureDetector(
                onTap: () {
                  context.go(AppRoutes.registerScreen);
                },
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
              
        ],
      ),
    );
  }
  
}

