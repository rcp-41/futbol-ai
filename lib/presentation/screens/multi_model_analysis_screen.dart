import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/text_styles.dart';
import '../../data/models/match_model.dart';
import '../providers/multi_model_analysis_provider.dart';
import '../widgets/multi_model/multi_model_analysis_view.dart';
import '../widgets/multi_model/verification_badge.dart';
import '../widgets/loading_overlay.dart'; // Ensure you have this or use CircularProgressIndicator

class MultiModelAnalysisScreen extends ConsumerWidget {
  final MatchModel match;

  const MultiModelAnalysisScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsyncValue = ref.watch(multiModelAnalysisStreamProvider(match.id));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Çoklu Model Analizi'),
            Text('${match.homeTeam.name} vs ${match.awayTeam.name}', 
                 style: TextStyles.caption.copyWith(color: Colors.white70)),
          ],
        ),
        actions: [
          analysisAsyncValue.when(
            data: (data) => data != null ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: VerificationBadge(verification: data.verification)),
            ) : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: analysisAsyncValue.when(
        data: (data) {
          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.analytics_outlined, size: 64, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('Bu maç için henüz çoklu model analizi başlatılmadı.', 
                       style: TextStyles.body1, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Şimdi Başlat (Tahmini 2-3 dk)'),
                    onPressed: () async {
                      try {
                        await ref.read(triggerMultiModelAnalysisProvider(match).future);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Analiz kuyruğa alındı! Lütfen bekleyin...')),
                        );
                      } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hata: $e')),
                        );
                      }
                    },
                  )
                ],
              ),
            );
          }

          return MultiModelAnalysisView(data: data);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Bir hata oluştu: $err')),
      ),
    );
  }
}
