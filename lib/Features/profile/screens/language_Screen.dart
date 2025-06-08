import 'package:flutter/material.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage;
  final List<String> _languages = [
    'العربية',
    'الكوردي',
    'English',
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBar(
              title: 'اللغة',
              showBackButton: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _languages.length,
                        itemBuilder: (context, index) {
                          final language = _languages[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: buildItem(language, theme),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RadioListTile<String> buildItem(String language, ThemeData theme) {
    return RadioListTile<String>(
      title: Text(
        language,
        style: const TextStyle(fontSize: 16),
        textAlign: language == "English" ? TextAlign.left : TextAlign.right,
      ),
      value: language,
      groupValue: _selectedLanguage,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedLanguage = value;
          });
        }
      },

      activeColor: theme.colorScheme.primary,
      controlAffinity: language == "English"
          ? ListTileControlAffinity.trailing
          : ListTileControlAffinity.leading, // Place radio button on the left
    );
  }
}
