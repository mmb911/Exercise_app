import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/exercise_provider.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyParts = ref.watch(bodyPartsProvider);
    final equipment = ref.watch(equipmentListProvider);
    final selectedBodyPart = ref.watch(selectedBodyPartProvider);
    final selectedEquipment = ref.watch(selectedEquipmentProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(selectedBodyPartProvider.notifier).state = null;
                      ref.read(selectedEquipmentProvider.notifier).state = null;
                      ref.read(selectedTargetProvider.notifier).state = null;
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Body Parts
                    Text(
                      'Body Part',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: bodyParts.map((part) {
                        final isSelected = selectedBodyPart == part;
                        return FilterChip(
                          label: Text(part),
                          selected: isSelected,
                          onSelected: (selected) {
                            ref.read(selectedBodyPartProvider.notifier).state =
                                selected ? part : null;
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Equipment
                    Text(
                      'Equipment',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: equipment.map((equip) {
                        final isSelected = selectedEquipment == equip;
                        return FilterChip(
                          label: Text(equip),
                          selected: isSelected,
                          onSelected: (selected) {
                            ref.read(selectedEquipmentProvider.notifier).state =
                                selected ? equip : null;
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
