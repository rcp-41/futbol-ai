import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/gemini_datasource.dart';
import '../../data/repositories/auth_repository.dart';

// ═══ Shared Datasource Providers ═══

final geminiDatasourceProvider = Provider<GeminiDatasource>(
  (ref) => GeminiDatasource(),
);

// ═══ Auth Providers ═══

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);
