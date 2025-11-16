import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';


class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController emailTextController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailTextController = TextEditingController();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplateWidget(title: context.tr("forgot_password"), childrens: [
      Form(
        key: _formKey,
        child: TextFormField(
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
      ),
      20.ph,
      Consumer(
        builder: (context, ref, child) {
          final isLoad = ref.watch(authProvider.select((e)=>e.forgotPasswordApiResponse.status)) == Status.loading;
          return CustomButtonWidget(
            isLoad: isLoad,
            title: context.tr("continue"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.read(authProvider.notifier).forgotPassword(email: emailTextController.text.trim());
              }
            },
          );
        }
      ),

    ]);
  }
}
