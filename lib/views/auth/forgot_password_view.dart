import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';


class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  late final TextEditingController confirmPasswordTextController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplateWidget(title: context.tr("forgot_password"), childrens: [
      Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailTextController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.emailAddress,
              validator: (value)=> value?.validateEmail(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.secondaryColor,
                ),
                labelText: context.tr("email"),
                hintText: context.tr("enter_email_address"),
              ),
            ),
            10.ph,
            GenericPasswordTextField(
                controller: passwordTextController,
                validator: (value)=>value?.validatePassword(),
                label: context.tr("password"),
                hint: context.tr("enter_password"),
              ),
              10.ph,
              GenericPasswordTextField(
                controller: confirmPasswordTextController,
                validator: (value)=>value?.validateConfirmPassword(passwordTextController.text),
                label: context.tr("confirm_password"),
                hint: context.tr("enter_password"),
              ),
          ],
        ),
      ),
      20.ph,
      Consumer(
        builder: (context, ref, child) {
          final isLoad = ref.watch(authProvider.select((e)=>e.forgotPasswordApiResponse.status)) == Status.loading;
          return CustomButtonWidget(
            isLoad: isLoad,
            title: context.tr("next"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.read(authProvider.notifier).forgotPassword(email: emailTextController.text.trim(), password: passwordTextController.text);
              }
            },
          );
        }
      ),

    ]);
  }
}
