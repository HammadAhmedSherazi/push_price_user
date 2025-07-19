import 'package:push_price_user/utils/extension.dart';


import '../../export_all.dart';

class CreateProfileView extends StatefulWidget {
  const CreateProfileView({super.key});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  late final TextEditingController nameTextController;
  late final TextEditingController addressTextController;
  late final TextEditingController phoneTextController;
  late final TextEditingController emailTextController;

  @override
  void initState() {
    nameTextController = TextEditingController();
    addressTextController = TextEditingController();
    phoneTextController = TextEditingController();
    emailTextController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      onButtonTap: (){
        AppRouter.push(NavigationView());
      },
      title: "Create Profile", showBottomButton: true, bottomButtonText: "continue", child: ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.horizontalPadding
      ),
      children: [
        Center(
          child: ProfileImageChanger(),
        ),
        20.ph,
        TextFormField(
          controller: nameTextController,
          decoration: InputDecoration(
            labelText: "Name",
            hintText: "Enter Name"
          ),
        ),
        10.ph,
        TextFormField(
          controller: addressTextController,
          decoration: InputDecoration(
            labelText: "Address",
            hintText: "Address (can add multiple addresses)"
          ),
        ),
        10.ph,
        TextFormField(
          controller: phoneTextController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            
            labelText: "Phone Number",
            hintText: "Enter Phone Number"
          ),
        ),
        10.ph,
        TextFormField(
          controller: emailTextController,
          decoration: InputDecoration(
            labelText: "Email Address",
            hintText: "Enter Email"
          ),
        ),
       
      ],
      
    ),);
  }
}