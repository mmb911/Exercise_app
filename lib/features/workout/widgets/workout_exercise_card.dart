import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../models/workout_exercise_model.dart';

class WorkoutExerciseCard extends StatelessWidget {
  final WorkoutExerciseModel exercise;
  final VoidCallback onToggle;

  const WorkoutExerciseCard({
    super.key,
    required this.exercise,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GlassCard(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Exercise Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: exercise.gifUrl,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80.w,
                  height: 80.h,
                  color: theme.colorScheme.surface,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    size: 32.sp,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Exercise Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.titleMedium?.color,
                      decoration: exercise.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        size: 12.sp,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          exercise.target,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 12.sp,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          exercise.equipment,
                          style: TextStyle(
                            fontSize: 11.sp,
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

            // Checkbox
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                value: exercise.isCompleted,
                onChanged: (_) => onToggle(),
                activeColor: theme.colorScheme.primary,
                checkColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
