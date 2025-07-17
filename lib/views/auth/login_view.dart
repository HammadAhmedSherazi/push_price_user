import 'package:flutter/material.dart';
import 'package:push_price_user/export_all.dart';
import 'package:push_price_user/utils/extension.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
                    RichText(
                textAlign: TextAlign.center,
        text: TextSpan(
      
      style: context.textStyle.bodyMedium!,
      
      children: [
        TextSpan(text: "You Already Have An Account?"),
        TextSpan(
          text: " Sign In",
          style: context.textStyle.bodyMedium!.copyWith(
            color: context.colors.primary
          ),
        ),
       
        
       
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
   
          prefixIcon: Icon(Icons.email_outlined, color: AppColors.secondaryColor),
       
          labelText: "Email",
          hintText: "Enter Email Address"
         
          
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
          
          suffixIcon: IconButton(onPressed: (){
            setState(() {
              showPass = !showPass;
            });
          }, icon: Icon( showPass? Icons.visibility : Icons.visibility_off, color: AppColors.secondaryColor)),
         
          
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
            value: rememberMeCheck , onChanged: (value){
            rememberMeCheck = value;
            setState(() {
              
            });
          }),
          ),
          Text("Remember Me", style: context.textStyle.displayMedium,),
          Spacer(),
          TextButton(onPressed: (){}, child: Text("Forgot Password?", style: context.textStyle.displayMedium!.copyWith(
            color: context.colors.primary
          ),),)
        ],
      ),
      20.ph,
      CustomButtonWidget(title: "login", onPressed: (){})
    ], );
  }
}