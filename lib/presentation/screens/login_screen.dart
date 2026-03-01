import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/analytics_service.dart';
import '../../core/utils/error_mapper.dart';
import '../providers/matches_provider.dart';

/// Login Screen — Email/Password ile giriş + kayıt + şifre sıfırlama
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Email ve şifre gerekli.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = ref.read(authRepositoryProvider);
      await auth.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      AnalyticsService.logLogin('email');
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = mapFirebaseAuthError(e.code);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Giriş başarısız. Tekrar deneyin.';
        _isLoading = false;
      });
    }
  }

  /// [E-04] Kayıt ol
  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Email ve şifre gerekli.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = ref.read(authRepositoryProvider);
      await auth.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      AnalyticsService.logSignUp('email');
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = mapFirebaseAuthError(e.code);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Kayıt başarısız. Tekrar deneyin.';
        _isLoading = false;
      });
    }
  }

  /// [E-05] Şifre sıfırlama
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Lütfen e-posta adresinizi girin.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = ref.read(authRepositoryProvider);
      await auth.sendPasswordResetEmail(email);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifre sıfırlama e-postası gönderildi.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = mapFirebaseAuthError(e.code);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'İşlem başarısız. Tekrar deneyin.';
        _isLoading = false;
      });
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = ref.read(authRepositoryProvider);
      await auth.signInAnonymously();
      AnalyticsService.logLogin('anonymous');
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() {
        _error = 'Anonim giriş başarısız. Tekrar deneyin.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Icon(
                  Icons.sports_soccer,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'FutbolAI',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Elit Futbol Analiz & Tahmin',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 48),

                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) =>
                      _isRegisterMode ? _register() : _signIn(),
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // [E-05] Şifremi Unuttum
                if (!_isRegisterMode)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : _resetPassword,
                      child: Text(
                        'Şifremi Unuttum',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                // Error
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),

                // Login / Register Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _isLoading
                        ? null
                        : (_isRegisterMode ? _register : _signIn),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _isRegisterMode ? 'Kayıt Ol' : 'Giriş Yap',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),

                // [E-04] Toggle Register / Login
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => setState(() {
                            _isRegisterMode = !_isRegisterMode;
                            _error = null;
                          }),
                  child: Text(
                    _isRegisterMode
                        ? 'Zaten hesabınız var mı? Giriş Yap'
                        : 'Hesabınız yok mu? Kayıt Ol',
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.dividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'veya',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.dividerColor)),
                  ],
                ),
                const SizedBox(height: 16),

                // Anonymous Login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _signInAnonymously,
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Anonim Devam Et'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
