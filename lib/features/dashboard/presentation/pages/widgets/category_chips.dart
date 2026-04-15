part of '../dashboard_page.dart';

class _CategoryChips extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedId;

  const _CategoryChips({
    required this.categories,
    required this.selectedId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A0A00),
      child: Column(
        children: [
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat.id == selectedId;
                return _CategoryChip(
                  category: cat,
                  isSelected: isSelected,
                  onTap: () => context
                      .read<DashboardBloc>()
                      .add(DashboardEvent.categorySelected(cat.id)),
                );
              },
            ),
          ),
          // Divider line
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CachedNetworkImage(
                  imageUrl: category.iconUrl,
                  width: 28,
                  height: 28,
                  color: isSelected ? Colors.white : Colors.white60,
                  errorWidget: (_, __, ___) => Icon(
                    Icons.category_outlined,
                    color: isSelected ? Colors.white : Colors.white60,
                    size: 28,
                  ),
                ),
                if (category.isNew)
                  Positioned(
                    top: -6,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 11,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 3),
                height: 2,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
