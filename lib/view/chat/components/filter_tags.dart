import 'package:flutter/material.dart';

import '../../../config_dev.dart';

class FilterTags extends StatefulWidget {
  final ValueChanged<List<int>> onSelectionChanged;

  const FilterTags({super.key, required this.onSelectionChanged});

  @override
  State<FilterTags> createState() => _FilterTagsState();
}

class _FilterTagsState extends State<FilterTags> {
  final Iterable<int> _tags = AppConfig.filterMap.keys;
  final ValueNotifier<List<int>> _selectedTags = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: _tags.map((tag) => _buildFilterItem(tag)).toList(),
    );
  }

  Widget _buildFilterItem(int index) {
    return ValueListenableBuilder<List<int>>(
      valueListenable: _selectedTags,
      builder: (context, selected, _) {
        final isSelected = selected.contains(index);
        return GestureDetector(
          onTap: () {
            _toggleTag(index);
          },
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey[300] : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              AppConfig.filterMap[index]!,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleTag(int index) {
    if (_selectedTags.value.contains(index)) {
      // remove tag
      _selectedTags.value = List.from(_selectedTags.value)..remove(index);
    } else {
      // add tag
      _selectedTags.value = List.from(_selectedTags.value)..add(index);
    }

    // Call the callback to notify outside
    widget.onSelectionChanged(_selectedTags.value);
  }

  @override
  void dispose() {
    _selectedTags.dispose();
    super.dispose();
  }
}
