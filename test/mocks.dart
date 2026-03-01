import 'package:mockito/annotations.dart';
import 'package:futbol_ai/data/repositories/analysis_repository.dart';
import 'package:futbol_ai/data/repositories/chat_repository.dart';
import 'package:futbol_ai/data/datasources/gemini_datasource.dart';

/// [T-02] Mock factory — run `dart run build_runner build` to generate mocks
@GenerateMocks([
  AnalysisRepository,
  ChatRepository,
  CloudFunctionDatasource,
])
void main() {}
