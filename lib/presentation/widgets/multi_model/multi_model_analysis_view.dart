import 'package:flutter/material.dart';
import '../../../data/models/multi_model_analysis_model.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import 'ai_result_tab.dart';
import 'consensus_tab.dart';

class MultiModelAnalysisView extends StatefulWidget {
  final MultiModelAnalysisModel data;

  const MultiModelAnalysisView({super.key, required this.data});

  @override
  State<MultiModelAnalysisView> createState() => _MultiModelAnalysisViewState();
}

class _MultiModelAnalysisViewState extends State<MultiModelAnalysisView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didUpdateWidget(MultiModelAnalysisView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If consensus just arrived, switch to it automatically
    if (oldWidget.data.status != 'completed' && widget.data.status == 'completed') {
      _tabController.animateTo(2); 
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.data.status == 'completed' || widget.data.consensusResult != null;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Gemini', icon: Icon(Icons.auto_awesome)),
            Tab(text: 'Claude', icon: Icon(Icons.psychology_alt)),
            Tab(text: 'Konsensüs', icon: Icon(Icons.groups)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTabContent(1, widget.data.geminiResult),
              _buildTabContent(2, widget.data.claudeResult),
              _buildTabContent(3, widget.data.consensusResult, isConsensus: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(int stage, dynamic result, {bool isConsensus = false}) {
    if (result != null) {
      if (isConsensus) {
        return ConsensusTab(result: result as ConsensusResult);
      }
      return AIResultTab(result: result as AIModelResult);
    }

    // Determine loading state based on overall status
    String message = 'Bekleniyor...';
    double progress = 0.0;
    
    switch (widget.data.status) {
      case 'pending': message = 'Sıraya alındı...'; progress = 0.1; break;
      case 'verifying': message = 'Veriler doğrulanıyor...'; progress = 0.3; break;
      case 'analyzing': message = 'Derin öğrenme modülleri çalışıyor...'; progress = 0.5; break;
      case 'ai_processing': 
        if (stage == 1) message = 'Gemini analizi oluşturuyor...';
        else if (stage == 2) message = 'Claude analizi oluşturuyor...';
        else message = 'Modellerin bitmesi bekleniyor...';
        progress = 0.7; 
        break;
      case 'consensus':
        if (isConsensus) {
           message = 'Modeller arası ortaklaşma (Konsensüs) hesaplanıyor...';
           progress = 0.9;
        } else {
           message = 'Tamamlandı.';
           progress = 1.0;
        }
        break;
      case 'failed':
        return Center(
          child: Text('Analiz Hatası: ${widget.data.error}\n\nDurum: ${widget.data.statusMessage}', 
                textAlign: TextAlign.center, style: const TextStyle(color: AppColors.error)),
        );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: progress, backgroundColor: AppColors.surfaceVariant),
          const SizedBox(height: 24),
          Text(message, style: TextStyles.h4, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(widget.data.statusMessage ?? '', style: TextStyles.body2, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
