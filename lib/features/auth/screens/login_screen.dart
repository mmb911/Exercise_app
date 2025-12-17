import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/presentation/widgets/core_ui.dart';
import '../widgets/social_auth_button.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/router/route_constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      // Navigation handled by router
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      // Navigation handled by router
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: isDark
                ? [
                    AppTheme.darkBackground,
                    AppTheme.darkSurface,
                    AppTheme.darkBackground,
                  ]
                : [
                    AppTheme.lightBackground,
                    Colors.white,
                    AppTheme.lightBackground,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo with Glow
                    Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonGreen.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            size: 80.sp,
                            color: AppTheme.neonGreen,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: -0.3, end: 0, duration: 500.ms),

                    SizedBox(height: 24.h),

                    // Welcome Title
                    Text(
                          'Welcome Back!',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(begin: -0.2, end: 0, duration: 400.ms),

                    SizedBox(height: 8.h),

                    Text(
                      'Sign in to continue your fitness journey',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                    SizedBox(height: 48.h),

                    // Email Field - Animated
                    CustomTextField(
                          controller: _emailController,
                          hintText: 'Enter your email',
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms)
                        .slideY(begin: 0.3, end: 0, duration: 400.ms),

                    SizedBox(height: 20.h),

                    // Password Field - Animated
                    CustomTextField(
                          controller: _passwordController,
                          hintText: 'Enter your password',
                          label: 'Password',
                          obscureText: _obscurePassword,
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: AppTheme.neonGreen,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 400.ms)
                        .slideY(begin: 0.3, end: 0, duration: 400.ms),

                    SizedBox(height: 32.h),

                    // Sign In Button - Animated
                    PrimaryButton(
                          text: 'Sign In',
                          onPressed: _isLoading ? null : _signInWithEmail,
                          isLoading: _isLoading,
                        )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms)
                        .slideY(begin: 0.3, end: 0, duration: 400.ms),

                    SizedBox(height: 24.h),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.textTheme.bodySmall!.color!
                                .withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: theme.textTheme.bodySmall!.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppTheme.textSecondary.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

                    SizedBox(height: 24.h),

                    // Google Sign In - Animated
                    SocialAuthButton(
                          text: 'Continue with Google',
                          onPressed: _signInWithGoogle,
                          isLoading: _isGoogleLoading,
                        )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 400.ms)
                        .slideY(begin: 0.3, end: 0, duration: 400.ms),

                    SizedBox(height: 32.h),

                    // Sign Up Link - Animated
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: theme.textTheme.bodyMedium!.color,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(RouteConstants.signup),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
