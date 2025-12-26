import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// -----------------------------------------------------------------------------
/// App Entry Point
/// -----------------------------------------------------------------------------
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KaLbarApp());
}

/// -----------------------------------------------------------------------------
/// App Shell (Theme / Routing Root)
/// -----------------------------------------------------------------------------
class KaLbarApp extends StatelessWidget {
  const KaLbarApp({super.key});

  static const primaryBlue = Color(0xFF1877F2);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KaLbar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

/// -----------------------------------------------------------------------------
/// Assets Registry
/// -----------------------------------------------------------------------------
class AppAssets {
  static const String splash = 'assets/images/splash.png';
  static const String ob1 = 'assets/images/onboarding_1.png';
  static const String ob2 = 'assets/images/onboarding_2.png';
  static const String ob3 = 'assets/images/onboarding_3.png';
}

/// -----------------------------------------------------------------------------
/// Splash Screen
/// -----------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _lift;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutBack),
    );
    _lift = Tween<double>(begin: 10, end: 0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );

    _anim.forward();

    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, anim, __, child) {
            final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
            return FadeTransition(opacity: curved, child: child);
          },
          transitionDuration: const Duration(milliseconds: 320),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(AppAssets.splash), context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final targetWidth = (w * 0.78).clamp(220.0, 360.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) {
              return Opacity(
                opacity: _fade.value,
                child: Transform.translate(
                  offset: Offset(0, _lift.value),
                  child: Transform.scale(
                    scale: _scale.value,
                    child: SizedBox(
                      width: targetWidth,
                      child: Image.asset(
                        AppAssets.splash,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------------
/// Onboarding
/// -----------------------------------------------------------------------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const primaryBlue = Color(0xFF1877F2);
  static const subtitleColor = Color(0xFF9290A1);
  static const backColor = Color(0xFFB8B8C7);
  static const dotInactive = Color(0xFFC9C9D6);
  static const double _controlsHeight = 56;

  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      imageAsset: AppAssets.ob1,
      title: 'Lorem Ipsum is simply\ndummy',
      subtitle: 'Lorem Ipsum is simply dummy text of\nthe printing and typesetting industry.',
    ),
    _OnboardData(
      imageAsset: AppAssets.ob2,
      title: 'Lorem Ipsum is simply\ndummy',
      subtitle: 'Lorem Ipsum is simply dummy text of\nthe printing and typesetting industry.',
    ),
    _OnboardData(
      imageAsset: AppAssets.ob3,
      title: 'Lorem Ipsum is simply\ndummy',
      subtitle: 'Lorem Ipsum is simply dummy text of\nthe printing and typesetting industry.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final p in _pages) {
      precacheImage(AssetImage(p.imageAsset), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
          return FadeTransition(opacity: curved, child: child);
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }

  void _goBack() {
    if (_index <= 0) return;

    _controller.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final imageHeight = size.height * 0.64;
    final bottomSafe = media.padding.bottom;

    final cardPadding = EdgeInsets.symmetric(horizontal: 26).copyWith(
      top: 24,
      bottom: 14 + bottomSafe + _controlsHeight,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) {
                final p = _pages[i];

                return Stack(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: Image.asset(
                        p.imageAsset,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: size.height - imageHeight,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 22,
                              spreadRadius: 0,
                              offset: Offset(0, -6),
                              color: Color(0x11000000),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: cardPadding,
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey(i),
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOut,
                            builder: (_, t, child) {
                              return Opacity(
                                opacity: t,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - t) * 10),
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    height: 1.18,
                                    color: Colors.black,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  p.subtitle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                    height: 1.6,
                                    color: subtitleColor,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26).copyWith(bottom: 14),
                  height: _controlsHeight + 14 + media.padding.bottom,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      _Dots(
                        count: _pages.length,
                        index: _index,
                        activeColor: primaryBlue,
                        inactiveColor: dotInactive,
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        width: 74,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          opacity: _index > 0 ? 1.0 : 0.0,
                          child: IgnorePointer(
                            ignoring: _index == 0,
                            child: OutlinedButton(
                              onPressed: _goBack,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: backColor,
                                side: const BorderSide(color: backColor, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ).copyWith(
                                overlayColor: WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return backColor.withOpacity(0.10);
                                  }
                                  return null;
                                }),
                              ),
                              child: const Text('Back'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        height: 40,
                        width: _index == _pages.length - 1 ? 118 : 86,
                        child: ElevatedButton(
                          onPressed: _goNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ).copyWith(
                            overlayColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.white.withOpacity(0.12);
                              }
                              return null;
                            }),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: Text(
                              _index == _pages.length - 1 ? 'Get Started' : 'Next',
                              key: ValueKey(_index),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final String imageAsset;
  final String title;
  final String subtitle;

  const _OnboardData({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  const _Dots({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final isActive = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 8,
          height: 8,
          margin: EdgeInsets.only(right: i == count - 1 ? 0 : 6),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

/// -----------------------------------------------------------------------------
/// Auth Domain Model
/// -----------------------------------------------------------------------------
class AuthUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String accessToken;
  final String refreshToken;

  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });
}

/// -----------------------------------------------------------------------------
/// Auth Service (In-Memory Test Credentials)
///
/// Test Logins:
///   - amir / 123
///   - test2 / 456
///   - miro / 789
/// -----------------------------------------------------------------------------
class AuthService {
  AuthService._();

  static const Duration _simulatedLatency = Duration(milliseconds: 450);

  static final Map<String, _TestAccount> _accounts = <String, _TestAccount>{
    'amir': _TestAccount(
      id: 1,
      username: 'amir',
      password: '123',
      firstName: 'Amir',
      lastName: 'User',
      email: 'amir@example.com',
      gender: 'male',
      imageUrl: 'https://i.pravatar.cc/150?u=amir',
    ),
    'test2': _TestAccount(
      id: 2,
      username: 'test2',
      password: '456',
      firstName: 'Test',
      lastName: 'Two',
      email: 'test2@example.com',
      gender: 'unspecified',
      imageUrl: 'https://i.pravatar.cc/150?u=test2',
    ),
    'miro': _TestAccount(
      id: 3,
      username: 'miro',
      password: '789',
      firstName: 'Miro',
      lastName: 'User',
      email: 'miro@example.com',
      gender: 'unspecified',
      imageUrl: 'https://i.pravatar.cc/150?u=miro',
    ),
  };

  static Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(_simulatedLatency);

    final u = username.trim();
    final account = _accounts[u];
    if (account == null || account.password != password) {
      throw const AuthException('Invalid username or password');
    }

    return AuthUser(
      id: account.id,
      username: account.username,
      email: account.email,
      firstName: account.firstName,
      lastName: account.lastName,
      gender: account.gender,
      image: account.imageUrl,
      accessToken: 'access_${account.username}_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'refresh_${account.username}_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class _TestAccount {
  final int id;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String imageUrl;

  const _TestAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.imageUrl,
  });
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// -----------------------------------------------------------------------------
/// Login Screen
/// -----------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const primaryBlue = Color(0xFF1877F2);
  static const subtleText = Color(0xFF6F6D7A);
  static const fieldBorder = Color(0xFFD7D6E2);
  static const fieldFill = Color(0xFFFFFFFF);
  static const linkBlue = Color(0xFF1877F2);
  static const danger = Color(0xFFFF4D7D);

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _remember = true;
  bool _obscure = true;
  bool _loading = false;

  String? _usernameError;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _username.addListener(_onFieldChanged);
    _password.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _username.removeListener(_onFieldChanged);
    _password.removeListener(_onFieldChanged);
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    // Keep the UI responsive by only rebuilding when needed.
    if (!mounted) return;
    setState(() {});
  }

  bool get _canSubmit => _username.text.trim().isNotEmpty && _password.text.isNotEmpty && !_loading;

  Future<void> _doLogin() async {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).clearSnackBars();

    setState(() => _usernameError = null);

    final u = _username.text.trim();
    final p = _password.text;

    if (u.isEmpty || p.isEmpty) {
      setState(() => _usernameError = u.isEmpty ? 'Invalid Username' : null);
      return;
    }

    setState(() => _loading = true);

    try {
      final user = await AuthService.login(username: u, password: p);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(user: user),
          transitionsBuilder: (_, anim, __, child) {
            final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
            return FadeTransition(opacity: curved, child: child);
          },
          transitionDuration: const Duration(milliseconds: 260),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _usernameError = 'Invalid Username');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString(), style: GoogleFonts.poppins()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required bool isError,
    required Widget? suffix,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: isError ? danger : fieldBorder, width: 1),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: const Color(0xFFB0AFBE),
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: fieldFill,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: border,
      focusedBorder: border.copyWith(borderSide: BorderSide(color: isError ? danger : fieldBorder, width: 1)),
      errorBorder: border,
      focusedErrorBorder: border,
      suffixIcon: suffix,
      errorStyle: GoogleFonts.poppins(fontSize: 10.5, color: danger, fontWeight: FontWeight.w400, height: 1.2),
      errorMaxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topPad = media.padding.top;
    final bottomPad = media.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(22, 18 + (topPad == 0 ? 18 : 0), 22, 18 + bottomPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  'Hello',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Again!',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: primaryBlue,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Welcome back you've\nbeen missed",
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: subtleText,
                  ),
                ),
                const SizedBox(height: 18),

                // Username
                Text(
                  'Username*',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 7),
                TextField(
                  controller: _username,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.black),
                  decoration: _fieldDecoration(
                    hint: 'Input text',
                    isError: _usernameError != null,
                    suffix: (_usernameError != null)
                        ? Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: IconButton(
                        onPressed: () {
                          _username.clear();
                          setState(() => _usernameError = null);
                        },
                        icon: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: danger,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                        splashRadius: 18,
                      ),
                    )
                        : null,
                  ).copyWith(
                    errorText: _usernameError,
                  ),
                ),
                const SizedBox(height: 12),

                // Password
                Text(
                  'Password*',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 7),
                TextField(
                  controller: _password,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _canSubmit ? _doLogin() : null,
                  style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.black),
                  decoration: _fieldDecoration(
                    hint: 'Input text',
                    isError: false,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      splashRadius: 18,
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18,
                        color: const Color(0xFF8F8DA3),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Transform.translate(
                      offset: const Offset(-6, 0),
                      child: Checkbox(
                        value: _remember,
                        onChanged: (v) => setState(() => _remember = v ?? true),
                        activeColor: primaryBlue,
                        side: const BorderSide(color: fieldBorder, width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Remember me',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7C7A8B),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(10, 10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: linkBlue,
                      ),
                      child: Text(
                        'Forget the password ?',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: linkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Submit
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _doLogin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      disabledBackgroundColor: primaryBlue.withOpacity(0.55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                    child: _loading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 14),
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1, height: 1, color: Color(0xFFE7E6EF))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'or continue with',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9C9AA9),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 1, height: 1, color: Color(0xFFE7E6EF))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook, size: 18, color: Color(0xFF1877F2)),
                        label: Text(
                          'Facebook',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D2B3A),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE1E0EA), width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata, size: 22, color: Color(0xFFEA4335)),
                        label: Text(
                          'Google',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D2B3A),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE1E0EA), width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "don't have an account ? ",
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8B8998),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: linkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------------
/// Home Screen
/// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final AuthUser user;
  const HomeScreen({super.key, required this.user});

  static String _tokenPreview(String token) {
    if (token.isEmpty) return '-';
    final n = token.length;
    final take = n < 24 ? n : 24;
    return '${token.substring(0, take)}...';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionsBuilder: (_, anim, __, child) {
                    final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
                    return FadeTransition(opacity: curved, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 220),
                ),
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(user.image),
                  backgroundColor: const Color(0xFFEDECF4),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${user.firstName} ${user.lastName}',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Username: ${user.username}',
              style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(
              'Email: ${user.email}',
              style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(
              'AccessToken: ${_tokenPreview(user.accessToken)}',
              style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
