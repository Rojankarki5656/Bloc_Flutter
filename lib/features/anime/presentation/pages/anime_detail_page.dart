// lib/features/anime/presentation/pages/anime_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/loaders/app_loader.dart';
import '../bloc/anime_detail_bloc.dart';
import '../widgets/anime_info_section.dart';
import '../widgets/character_section.dart';
import '../widgets/related_section.dart';

class AnimeDetailPage extends StatefulWidget {
  final String id;
  const AnimeDetailPage({super.key, required this.id});

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  late final AnimeDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<AnimeDetailBloc>();
    _bloc.add(LoadAnimeDetail(widget.id));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
          builder: (context, state) {
            if (state is AnimeDetailLoading) {
              return const AppLoader();
            }

            if (state is AnimeDetailError) {
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
                        _bloc.add(RefreshAnimeDetail(widget.id));
                      },
                      style: AppTheme.primaryButtonStyle,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is AnimeDetailLoaded) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Banner / Poster
                    _buildHeroBanner(state),
                    SizedBox(height: 16.h),
                    // Info Section
                    AnimeInfoSection(anime: state.anime),
                    SizedBox(height: 24.h),
                    // Characters
                    if (state.characters.isNotEmpty)
                      CharacterSection(characters: state.characters),
                    SizedBox(height: 24.h),
                    // Related
                    if (state.relations.isNotEmpty)
                      RelatedSection(relations: state.relations),
                    SizedBox(height: 40.h),
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

  Widget _buildHeroBanner(AnimeDetailLoaded state) {
    return Stack(
      children: [
        // Background Image
        SizedBox(
          height: 300.h,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: state.anime.bannerImage ?? state.anime.poster ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.borderColor,
            ),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.borderColor,
              child: Icon(
                Icons.broken_image,
                color: AppTheme.textMuted,
                size: 48.sp,
              ),
            ),
          ),
        ),
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.backgroundColor.withOpacity(0.2),
                  AppTheme.backgroundColor,
                ],
              ),
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: 48.h,
          left: 16.w,
          child: IconButton(
            onPressed: () => context.push('/'),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.textPrimary,
              size: 24.sp,
            ),
          ),
        ),
        // Title
        Positioned(
          bottom: 16.h,
          left: 16.w,
          right: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.anime.title,
                style: AppTheme.displaySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (state.anime.averageScore != null)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16.sp,
                          color: AppTheme.primaryGold,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          state.anime.averageScore.toString(),
                          style: AppTheme.labelMedium.copyWith(
                            color: AppTheme.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  if (state.anime.episodes != null) ...[
                    SizedBox(width: 12.w),
                    Text(
                      '${state.anime.episodes} eps',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                  if (state.anime.format != null) ...[
                    SizedBox(width: 12.w),
                    Text(
                      state.anime.format!,
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}