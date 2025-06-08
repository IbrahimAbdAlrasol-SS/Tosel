import 'package:Tosell/Features/settings/widgets/support_card_item.dart';
import 'package:Tosell/Features/settings/widgets/support_enum.dart';
import 'package:Tosell/Features/settings/widgets/support_model.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SupportRecordScreen extends StatefulWidget {
  const SupportRecordScreen({super.key});

  @override
  State<SupportRecordScreen> createState() => _SupportRecordScreenState();
}

class _SupportRecordScreenState extends State<SupportRecordScreen> {
  final List<SupportModel> supports = _generateSupports(1000);
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  int? _statusFilter;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSupports = supports.where((support) {
      final matchesSearch = support.description.contains(_searchQuery) ||
          support.id.contains(_searchQuery);
      final matchesStatus =
          _statusFilter == null || support.statusIndex == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text('قائمة الدعم السابق (${filteredSupports.length})',
                  style: const TextStyle(fontSize: 20) , ),
              pinned: true,
              floating: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.vertical_align_top,
                    color: Color(0xff16CA8B),
                  ),
                  onPressed: () => _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    // Search Bar
                    CustomTextFormField(
                      label: '',
                      showLabel: false,
                      hint: 'حالة المشكلة',
                      prefixInner: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/svg/search.svg",
                          color: const Color(0xff16CA8B),
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                    const Gap(10),

                    // Status Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // زر "الكل"
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                'الكل',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _statusFilter == null
                                      ? Colors.white
                                      : const Color(0xff16CA8B),
                                ),
                              ),
                              selected: _statusFilter == null,
                              onSelected: (_) =>
                                  setState(() => _statusFilter = null),
                              backgroundColor: _statusFilter == null
                                  ? const Color(0xff16CA8B)
                                  : Colors.white,
                              selectedColor: const Color(0xff16CA8B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: _statusFilter == null
                                      ? Colors.transparent
                                      : const Color(0xff16CA8B),
                                  width: 1,
                                ),
                              ),
                              labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                          ),

                          // باقي الخيارات
                          ...SupportStatus.values.asMap().entries.map((entry) {
                            final index = entry.key;
                            final status = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(
                                  status.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _statusFilter == index
                                        ? Colors.white
                                        : const Color(0xff16CA8B),
                                  ),
                                ),
                                selected: _statusFilter == index,
                                onSelected: (_) =>
                                    setState(() => _statusFilter = index),
                                backgroundColor: _statusFilter == index
                                    ? const Color(0xff16CA8B)
                                    : Colors.white,
                                selectedColor: const Color(0xff16CA8B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(
                                    color: _statusFilter == index
                                        ? Colors.transparent
                                        : const Color(0xff16CA8B),
                                    width: 1,
                                  ),
                                ),
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                              ),
                            );
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            if (filteredSupports.isEmpty) {
              return const Center(child: Text('لا توجد نتائج'));
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: filteredSupports.length,
              itemBuilder: (context, index) {
                return SupportCardItem(
                  key: ValueKey(filteredSupports[index].id),
                  support: filteredSupports[index],
                  onTap: () => _showDetails(context, filteredSupports[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, SupportModel support) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تفاصيل البلاغ #${support.id}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Divider(),
              SupportCardItem(
                support: support,
                isExpanded: true,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<SupportModel> _generateSupports(int count) {
    final problems = [
      'مشكلة في نظام الدفع',
      'طلب استرجاع منتج',
      'تأخر في التوصيل',
      'مشكلة في تسجيل الدخول',
      'استفسار عن الفاتورة'
    ];

    return List.generate(count, (index) {
      return SupportModel(
        id: 'TS-${1000 + index}',
        time: '${2024 + (index % 3)}-${(index % 12) + 1}-${(index % 28) + 1}',
        description: '${problems[index % problems.length]} (${index + 5000})',
        statusIndex: index % SupportStatus.values.length,
      );
    });
  }
}
