// lib/features/anime/presentation/widgets/character_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/character.dart';

class CharacterSection extends StatelessWidget {
  final List<Character> characters;

  const CharacterSection({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Characters & Voice Actors',
                style: AppTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...characters.take(6).map((character) {
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppTheme.borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Character Avatar
                  _buildAvatar(
                    imageUrl: character.image,
                    name: character.name,
                    size: 40.w,
                  ),
                  SizedBox(width: 12.w),
                  // Character Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/character/${character.id}'),
                          child: Text(
                            character.name,
                            style: AppTheme.titleSmall,
                          ),
                        ),
                        Text(
                          character.role ?? 'Character',
                          style: AppTheme.labelMedium.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Voice Actor
                  if (character.voiceActor != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => context.go('/people/${character.voiceActor!.id}'),
                          child: Text(
                            character.voiceActor!.name,
                            style: AppTheme.titleSmall.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Text(
                          'Japanese',
                          style: AppTheme.labelMedium.copyWith(
                            color: AppTheme.textMuted,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    _buildAvatar(
                      imageUrl: character.voiceActor!.image,
                      name: character.voiceActor!.name,
                      size: 40.w,
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAvatar({
    required String? imageUrl,
    required String name,
    required double size,
  }) {
    return ClipOval(
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: size,
                height: size,
                color: AppTheme.borderColor,
              ),
              errorWidget: (context, url, error) => Container(
                width: size,
                height: size,
                color: AppTheme.borderColor,
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppTheme.textMuted,
                      fontSize: size * 0.5,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: size,
              height: size,
              color: AppTheme.borderColor,
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: AppTheme.headlineSmall.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: size * 0.5,
                  ),
                ),
              ),
            ),
    );
  }
}