import 'package:flutter/gestures.dart';
import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;

  @override
  void initState() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    super.initState();
  }

  bool showPass = true;
  bool rememberMeCheck = false;

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplateWidget(
      bottomWidget: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: context.textStyle.bodyMedium!,

                children: [
                  TextSpan(text: "Don't have an account?"),
                  TextSpan(
                    text: " Sign Up",
                    style: context.textStyle.bodyMedium!.copyWith(
                      color: context.colors.primary,
                    ),
                    recognizer: TapGestureRecognizer()
          ..onTap = () {
            AppRouter.pushReplacement(SignUpView());
          },
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: context.textStyle.bodyMedium!.copyWith(
                  color: context.colors.primary,
                ),

                children: [
                  TextSpan(text: "Terms & Conditions",  recognizer: TapGestureRecognizer()
          ..onTap = () {
           
          },),
                  TextSpan(text: "  |  "),
                  TextSpan(text: "Privacy Policy",  recognizer: TapGestureRecognizer()
          ..onTap = () {
           
          },),
                ],
              ),
            ),
          ],
        ),
      ),
      
      title: "Sign In",
      childrens: [
        TextFormField(
          controller: emailTextController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.secondaryColor,
            ),

            labelText: "Email",
            hintText: "Enter Email Address",
          ),
        ),
        10.ph,
        TextFormField(
          controller: passwordTextController,
          obscureText: showPass,

          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: AppColors.secondaryColor),

            labelText: "Password",
            hintText: "Enter Password",

            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPass = !showPass;
                });
              },
              icon: Icon(
                showPass ? Icons.visibility : Icons.visibility_off,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
        // 10.ph,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 0.8,
              child: Switch.adaptive(
                padding: EdgeInsets.zero,

                activeColor: AppColors.primaryColor,
                value: rememberMeCheck,
                onChanged: (value) {
                  rememberMeCheck = value;
                  setState(() {});
                },
              ),
            ),
            Text("Remember Me", style: context.textStyle.displayMedium),
            Spacer(),
            TextButton(
              onPressed: () {
                AppRouter.push(ForgotPasswordView());
              },
              child: Text(
                "Forgot Password?",
                style: context.textStyle.displayMedium!.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ],
        ),
        20.ph,
        CustomButtonWidget(title: "login", onPressed: () {
          AppRouter.push(NavigationView());
        }),
      ],
    );
  }
}
