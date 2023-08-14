import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/repository/auth_repository.dart';
import 'package:nike_ecommerce/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackgroundColor = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(const Size.fromHeight(56)),
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
                borderSide:
                    const BorderSide(color: onBackgroundColor, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            snackBarTheme: SnackBarThemeData(
                backgroundColor: themeData.colorScheme.primary,
                contentTextStyle: const TextStyle(fontFamily: 'Vazir'))),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final bloc = AuthBloc(authRepository);
              bloc.stream.forEach((state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.exception.massage)));
                }
              });
              bloc.add(AuthStarted());
              return bloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 48, right: 48),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthLoading ||
                      current is AuthError ||
                      current is AuthInitial;
                },
                builder: (context, state) {
                  return Column(
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
                        state.isLoginMode ? 'خوش آمدید' : 'ثبت نام کنید',
                        style: const TextStyle(
                            color: onBackgroundColor, fontSize: 22),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.isLoginMode
                            ? 'لطفا وارد حساب کاربری خود شوید'
                            : 'ایمیل و رمز عبور خود را تعیین کنید',
                        style: const TextStyle(
                            color: onBackgroundColor, fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(label: Text('آدرس ایمیل')),
                      ),
                      const SizedBox(height: 16),
                      _PasswordTextField(
                        onBackgroundColor: onBackgroundColor,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                                AuthButtonIsClicked(usernameController.text,
                                    passwordController.text));
                          },
                          child: state is AuthLoading
                              ? const CircularProgressIndicator()
                              : Text(state.isLoginMode ? 'ورود' : 'ثبت نام')),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.isLoginMode
                                ? 'حساب کاربری ندارید؟'
                                : 'حساب کاربری دارید؟',
                            style: TextStyle(
                                color: onBackgroundColor.withOpacity(0.7)),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthModeChangeIsClicked());
                            },
                            child: Text(
                              state.isLoginMode ? 'ثبت نام کنید' : 'وارد شوید',
                              style: TextStyle(
                                color: themeData.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordTextField({
    Key? key,
    required this.onBackgroundColor,
    required this.controller,
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
      controller: widget.controller,
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
