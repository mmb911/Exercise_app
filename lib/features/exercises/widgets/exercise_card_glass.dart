import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../../../models/exercise_model.dart';

class ExerciseCardGlass extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onTap;

  const ExerciseCardGlass({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // Exercise Image with Hero
                Hero(
                  tag: 'exercise-${exercise.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl: exercise.gifUrl,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Skeletonizer(
                        enabled: true,
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          color: theme.colorScheme.surface,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          size: 40.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // Exercise Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.my_location,
                            size: 14.sp,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              exercise.target,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 14.sp,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              exercise.equipment,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: theme.colorScheme.primary.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
