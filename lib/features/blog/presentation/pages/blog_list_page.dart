// lib/features/blog/presentation/pages/blog_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/blog_bloc.dart';
import '../widgets/blog_card.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  late final BlogBloc _blogBloc;

  @override
  void initState() {
    super.initState();
    _blogBloc = getIt<BlogBloc>();
    _blogBloc.add(LoadBlogPosts());
  }

  @override
  void dispose() {
    _blogBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        ),
        title: Text(
          'Blog',
          style: AppTheme.headlineSmall,
        ),
      ),
      body: BlocProvider.value(
        value: _blogBloc,
        child: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BlogError) {
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
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        _blogBloc.add(RefreshBlogPosts());
                      },
                      style: AppTheme.primaryButtonStyle,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is BlogLoaded) {
              final sortedPosts = [...state.posts]
                ..sort((a, b) => b.date.compareTo(a.date));
              final featured = sortedPosts.isNotEmpty ? sortedPosts.first : null;
              final rest = sortedPosts.skip(1).toList();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (featured != null) ...[
                      Text(
                        'Featured Post',
                        style: AppTheme.headlineSmall,
                      ),
                      SizedBox(height: 12.h),
                      BlogCard(
                        post: featured,
                        featured: true,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'All Posts',
                        style: AppTheme.headlineSmall,
                      ),
                      SizedBox(height: 12.h),
                    ],
                    ...rest.map((post) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: BlogCard(post: post),
                      );
                    }),
                    if (rest.isEmpty && featured == null)
                      Center(
                        child: Text(
                          'No posts yet',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}