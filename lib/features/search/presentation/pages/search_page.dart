// lib/features/search/presentation/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/search_bloc.dart';
import '../widgets/search_bar.dart';
import '../widgets/search_result_card.dart';
import '../widgets/filter_panel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchBloc _searchBloc;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBloc = getIt<SearchBloc>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.only(top: 48.h, left: 16.w, right: 16.w),
            child: SearchBarWidget(
              controller: _controller,
              onSubmitted: (query) {
                _searchBloc.add(SearchSubmitted(query));
              },
              onCleared: () {
                _searchBloc.add(ClearSearch());
              },
            ),
          ),
          // Results
          Expanded(
            child: BlocProvider.value(
              value: _searchBloc,
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80.sp,
                            color: AppTheme.textMuted,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Search for anime',
                            style: AppTheme.headlineSmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Find your favorite shows',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.sp,
                            color: AppTheme.errorColor,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.message,
                            style: AppTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SearchLoaded) {
                    if (state.results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60.sp,
                              color: AppTheme.textMuted,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No results found for "${state.query}"',
                              style: AppTheme.headlineSmall.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Try different keywords',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          if (state.hasMore) {
                            _searchBloc.add(LoadMoreSearchResults());
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: state.results.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.results.length) {
                            if (state.hasMore) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.all(16.h),
                                child: Text(
                                  'End of results',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.textMuted,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                          }
                          final result = state.results[index];
                          return SearchResultCard(
                            result: result,
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoaded && state.results.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: AppTheme.surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                  builder: (context) => FilterPanel(
                    onApply: (filters) {
                      _searchBloc.add(ApplySearchFilters(
                        genre: filters['genre'],
                        format: filters['format'],
                        status: filters['status'],
                        sort: filters['sort'],
                      ));
                    },
                  ),
                );
              },
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.backgroundColor,
              child: const Icon(Icons.filter_list),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}