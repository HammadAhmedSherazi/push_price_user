import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  late final TextEditingController passwordTextController;
  late final TextEditingController confirmPasswordTextController;

   @override
  void initState() {
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
    super.initState();
  }
  bool showPass = true;
  bool showConfirmPass = true;
  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplateWidget(
       title: "Forgot Password",
      childrens: [
        
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
        10.ph,
        TextFormField(
          controller: confirmPasswordTextController,
          obscureText: showConfirmPass,

          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: AppColors.secondaryColor),

            labelText: "Confirm Password",
            hintText: "Enter Confirm Password",

            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showConfirmPass = !showConfirmPass;
                });
              },
              icon: Icon(
                showConfirmPass ? Icons.visibility : Icons.visibility_off,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
        // 10.ph,
        
        20.ph,
        CustomButtonWidget(title: "confirm password", onPressed: () {
          AppRouter.customback(times: 3);
        }),
     
      ],);

  }
}



