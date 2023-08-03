import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackgroundColor = Colors.white;
    return Theme(
      data: themeData.copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(56)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(onBackgroundColor),
            foregroundColor:
                MaterialStateProperty.all(themeData.colorScheme.secondary),
          ),
        ),
        colorScheme:
            themeData.colorScheme.copyWith(onSurface: onBackgroundColor),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: onBackgroundColor),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: onBackgroundColor, width: 1),
              borderRadius: BorderRadius.circular(12),
            )),
      ),
      child: Scaffold(
        backgroundColor: themeData.colorScheme.secondary,
        body: Padding(
          padding: const EdgeInsets.only(left: 48, right: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/nike_logo.png',
                color: onBackgroundColor,
                width: 120,
              ),
              const SizedBox(height: 24),
              Text(
                isLogin ? 'خوش آمدید' : 'ثبت نام کنید',
                style: const TextStyle(color: onBackgroundColor, fontSize: 22),
              ),
              const SizedBox(height: 16),
              Text(
                isLogin
                    ? 'لطفا وارد حساب کاربری خود شوید'
                    : 'ایمیل و رمز عبور خود را تعیین کنید',
                style: const TextStyle(color: onBackgroundColor, fontSize: 18),
              ),
              const SizedBox(height: 24),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(label: Text('آدرس ایمیل')),
              ),
              const SizedBox(height: 16),
              const _PasswordTextField(onBackgroundColor: onBackgroundColor),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {}, child: Text(isLogin ? 'ورود' : 'ثبت نام')),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? 'حساب کاربری ندارید؟' : 'حساب کاربری دارید؟',
                    style: TextStyle(color: onBackgroundColor.withOpacity(0.7)),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'ثبت نام کنید' : 'وارد شوید',
                      style: TextStyle(
                        color: themeData.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    Key? key,
    required this.onBackgroundColor,
  }) : super(key: key);

  final Color onBackgroundColor;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: const Text('رمز عبور'),
        suffixIcon: IconButton(
          icon: Icon(obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          color: widget.onBackgroundColor.withOpacity(0.6),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
    );
  }
}
