import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';

class RegistrationSearchDropDown<T> extends StatefulWidget {
  final String label;
  final String hint;
  final T? selectedValue;
  final String Function(T) itemAsString;
  final void Function(T?) onChanged;
  final String? Function(String?)? validator;
  final Future<List<T>> Function(String query) asyncItems;
  final Widget Function(BuildContext, T)? itemBuilder;
  final String emptyText;
  final String errorText;

  const RegistrationSearchDropDown({
    super.key,
    required this.label,
    required this.hint,
    this.selectedValue,
    required this.itemAsString,
    required this.onChanged,
    this.validator,
    required this.asyncItems,
    this.itemBuilder,
    this.emptyText = "لا توجد نتائج",
    this.errorText = "حدث خطأ أثناء البحث",
  });

  @override
  State<RegistrationSearchDropDown<T>> createState() => _RegistrationSearchDropDownState<T>();
}

class _RegistrationSearchDropDownState<T> extends State<RegistrationSearchDropDown<T>>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  
  OverlayEntry? _overlayEntry;
  List<T> _suggestions = [];
  bool _isLoading = false;
  bool _showDropdown = false;
  bool _hasError = false;
  T? _selectedItem;
  Timer? _debounceTimer;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedValue;
    if (_selectedItem != null) {
      _controller.text = widget.itemAsString(_selectedItem!);
    }
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showSuggestions();
      if (_controller.text.isNotEmpty) {
        _onTextChanged(_controller.text);
      }
    } else {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!_focusNode.hasFocus) {
          _hideSuggestions();
        }
      });
    }
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();
    
    if (value.isNotEmpty) {
      _debounceTimer = Timer(const Duration(milliseconds: 400), () {
        _searchItems(value);
      });
    } else {
      setState(() {
        _suggestions = [];
        _isLoading = false;
        _hasError = false;
      });
      _updateOverlay();
    }
  }

  Future<void> _searchItems(String query) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await widget.asyncItems(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
          _hasError = false;
        });
        _updateOverlay();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
          _hasError = true;
        });
        _updateOverlay();
      }
    }
  }

  void _showSuggestions() {
    if (!_showDropdown) {
      setState(() => _showDropdown = true);
      _createOverlay();
      _animationController.forward();
    }
  }

  void _hideSuggestions() {
    if (_showDropdown) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() => _showDropdown = false);
          _removeOverlay();
        }
      });
    }
  }

  void _createOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(builder: _buildOverlay);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(T item) {
    setState(() {
      _selectedItem = item;
      _controller.text = widget.itemAsString(item);
    });
    widget.onChanged(item);
    _focusNode.unfocus();
    _hideSuggestions();
  }

  void _clearSelection() {
    setState(() {
      _selectedItem = null;
      _controller.clear();
    });
    widget.onChanged(null);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(AppSpaces.small),
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            validator: widget.validator,
            onChanged: _onTextChanged,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: Color(0xFF698596),
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: context.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: context.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(
                  color: context.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              suffixIcon: _buildSuffixIcon(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuffixIcon() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              context.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    if (_selectedItem != null) {
      return IconButton(
        onPressed: _clearSelection,
        icon: Icon(
          Icons.clear,
          color: context.colorScheme.secondary,
          size: 20,
        ),
      );
    }

    return Icon(
      Icons.search,
      color: context.colorScheme.primary,
      size: 24,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width - 32,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 70),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          shadowColor: Colors.black26,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                context.colorScheme.primary,
              ),
            ),
            const Gap(8),
            Text(
              'جاري البحث...',
              style: TextStyle(color: context.colorScheme.secondary),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            const Gap(8),
            Text(
              widget.errorText,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_suggestions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: context.colorScheme.secondary),
            const Gap(8),
            Text(
              widget.emptyText,
              style: TextStyle(color: context.colorScheme.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: _suggestions.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: context.colorScheme.outline.withOpacity(0.2),
        indent: 12,
        endIndent: 12,
      ),
      itemBuilder: (context, index) {
        final item = _suggestions[index];
        final isSelected = _selectedItem == item;
        
        return InkWell(
          onTap: () => _selectItem(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? context.colorScheme.primary.withOpacity(0.1)
                  : null,
            ),
            child: widget.itemBuilder?.call(context, item) ??
                Text(
                  widget.itemAsString(item),
                  style: TextStyle(
                    color: isSelected 
                        ? context.colorScheme.primary
                        : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
          ),
        );
      },
    );
  }
}