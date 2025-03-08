import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'carousel_flowdelegate.dart';
import 'filter_item.dart';

@immutable
class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.filters,
    required this.onFilterChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
  });

  final List<Color> filters;
  final void Function(Color selectedColor) onFilterChanged;
  final EdgeInsets padding;

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  late final PageController _controller;
  late int _page;

  int get filterCount => widget.filters.length;

  Color itemColor(int index) => widget.filters[index % filterCount];

  @override
  void initState() {
    super.initState();
    _page = 0;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
      widget.onFilterChanged(widget.filters[page]);
    }
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildShadowGradient(),
          _buildCarousel(),
          _buildSelectionRing(),
        ],
      ),
    );
  }

  Widget _buildShadowGradient() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black54,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 100, 
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: filterCount,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onFilterTapped(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FilterItem(
                color: itemColor(index),
                onFilterSelected: () => _onFilterTapped(index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionRing() {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 6, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
