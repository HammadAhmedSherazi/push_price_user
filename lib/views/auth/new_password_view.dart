import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class NewPasswordView extends StatefulWidget {
  final String code;
  const NewPasswordView({super.key, required this.code});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  late final TextEditingController passwordTextController;
  late final TextEditingController confirmPasswordTextController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplateWidget(
      title: context.tr("reset_password"),
      onBackTap: (){
        AppRouter.customback(times: 2);
      },
      childrens: [
        Form(
          key: _formKey,
          child: Column(
            children: [
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
            final isLoad = ref.watch(authProvider.select((e)=>e.resetPasswordApiResponse.status)) == Status.loading;
            return CustomButtonWidget(
              isLoad: isLoad,
              title: context.tr("confirm_password"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ref.read(authProvider.notifier).resetPassword(password: passwordTextController.text.trim(), otp: widget.code );
                }
              },
            );
          }
        ),
      ],
    );
  }
}
