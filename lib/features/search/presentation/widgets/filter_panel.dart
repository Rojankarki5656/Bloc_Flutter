// lib/features/search/presentation/widgets/filter_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';

class FilterPanel extends StatefulWidget {
  final Function(Map<String, String?>) onApply;

  const FilterPanel({super.key, required this.onApply});

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  String? _genre;
  String? _format;
  String? _status;
  String? _sort;

  final List<String> _genres = [
    'Action', 'Adventure', 'Comedy', 'Drama', 'Fantasy',
    'Horror', 'Mystery', 'Romance', 'Sci-Fi', 'Slice of Life',
    'Sports', 'Thriller', 'Supernatural', 'Magic', 'Mecha'
  ];

  final List<String> _formats = ['TV', 'Movie', 'OVA', 'ONA', 'Special'];
  final List<String> _statuses = ['RELEASING', 'FINISHED', 'NOT_YET_RELEASED'];
  final List<String> _sorts = ['POPULARITY_DESC', 'SCORE_DESC', 'TRENDING_DESC', 'START_DATE_DESC'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filters',
            style: AppTheme.headlineSmall,
          ),
          SizedBox(height: 20.h),
          // Genre
          _buildDropdown('Genre', _genres, _genre, (value) {
            setState(() => _genre = value);
          }),
          SizedBox(height: 16.h),
          // Format
          _buildDropdown('Format', _formats, _format, (value) {
            setState(() => _format = value);
          }),
          SizedBox(height: 16.h),
          // Status
          _buildDropdown('Status', _statuses, _status, (value) {
            setState(() => _status = value);
          }),
          SizedBox(height: 16.h),
          // Sort
          _buildDropdown('Sort By', _sorts, _sort, (value) {
            setState(() => _sort = value);
          }),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _genre = null;
                      _format = null;
                      _status = null;
                      _sort = null;
                    });
                  },
                  child: Text('Clear All'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply({
                      'genre': _genre,
                      'format': _format,
                      'status': _status,
                      'sort': _sort,
                    });
                    Navigator.pop(context);
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.labelLarge,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppTheme.borderColor,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                'All',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
              value: selected,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All'),
                ),
                ...items.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                )),
              ],
              onChanged: onChanged,
              style: AppTheme.bodyMedium,
              dropdownColor: AppTheme.surfaceColor,
            ),
          ),
        ),
      ],
    );
  }
}