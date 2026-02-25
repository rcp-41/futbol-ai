import 'package:flutter/material.dart';

import '../../../data/models/analysis_model.dart';
import 'category_score_row.dart';

/// 8 kategori akordiyon — ExpansionTile listesi
class CategoryAccordion extends StatelessWidget {
  final AnalysisCategories categories;
  const CategoryAccordion({required this.categories, super.key});

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();

    return Column(
      children: items.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            leading: Text(item.icon, style: const TextStyle(fontSize: 20)),
            title: Text(
              item.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            subtitle: Text(
              'Ağırlık: %${(item.score.weight * 100).toInt()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: CategoryScoreRow(
                  homeScore: item.score.homeScore,
                  awayScore: item.score.awayScore,
                  detail: item.score.detail,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<_CategoryItem> _buildItems() {
    return [
      _CategoryItem('💪', 'Güç Analizi', categories.power ?? const CategoryScore()),
      _CategoryItem('🎯', 'Taktik Analiz', categories.tactics ?? const CategoryScore()),
      _CategoryItem('🧠', 'Psikoloji', categories.psychology ?? const CategoryScore()),
      _CategoryItem('🌍', 'Dış Faktörler', categories.externalFactors ?? const CategoryScore()),
      _CategoryItem('💰', 'Piyasa', categories.market ?? const CategoryScore()),
      _CategoryItem('⚖️', 'Hakem', categories.referee ?? const CategoryScore()),
      _CategoryItem('⚽', 'Duran Top', categories.setPieces ?? const CategoryScore()),
      _CategoryItem('🏃', 'Fiziksel & Fikstür', categories.physical ?? const CategoryScore()),
    ];
  }
}

class _CategoryItem {
  final String icon;
  final String name;
  final CategoryScore score;
  _CategoryItem(this.icon, this.name, this.score);
}
