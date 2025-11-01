import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class CreateProfileView extends StatefulWidget {
  final bool? isEdit;
  const CreateProfileView({super.key, this.isEdit = false});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {

  late final TextEditingController nameTextController;
  late final TextEditingController employeeIdTextController;
  late final TextEditingController phoneTextController;
  late final TextEditingController emailTextController;
  late final TextEditingController addressTextController;

  @override
  void initState() {
    nameTextController = TextEditingController(
      text: widget.isEdit! ? "John Smith" : null,
    );
    employeeIdTextController = TextEditingController(
      text: widget.isEdit! ? "123 456 789" : null,
    );
    phoneTextController = TextEditingController(
      text: widget.isEdit! ? "00000000" : null,
    );
    emailTextController = TextEditingController(
      text: widget.isEdit! ? "Abc@gmail.com" : null,
    );
    addressTextController = TextEditingController(
      text: widget.isEdit! ? "" : null,
    );
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String initialCountryCode = "US";
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomScreenTemplate(
        customBottomWidget: Consumer(
          builder: (context, ref, child) {
            final isLoad =
                ref.watch(
                  authProvider.select(
                    (e) => e.completeProfileApiResponse.status,
                  ),
                ) ==
                Status.loading;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.horizontalPadding,
              ),
              child: CustomButtonWidget(
                isLoad: isLoad,
                title: widget.isEdit!
                    ? context.tr("save")
                    : context.tr("continue"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final isoCode = IsoCode.values.firstWhere(
                        (c) => c.name == initialCountryCode.toUpperCase(),
                        orElse: () => IsoCode.US, // fallback
                      );

                      final parsed = PhoneNumber.parse(
                        phoneTextController.text,
                        destinationCountry: isoCode,
                      );

                      if (parsed.isValid()) {
                        Map<String, dynamic> data = {
                          "full_name": nameTextController.text,
                          "phone_number": parsed.international,
                          "address": addressTextController.text,
                        };
                        final profileImage = ref.watch(authProvider.select((e)=>e.imageUrl)) ?? "";
                        if(profileImage != ""){
                          data['profile_image'] = profileImage;
                        }
                        // print(data);
                        ref.read(authProvider.notifier).completeProfile(profileData:data );
                      } else {
                        Helper.showMessage(
                          context,
                          message: "Please enter a valid phone number",
                        );
                      }
                    } catch (e) {
                      Helper.showMessage(
                        context,
                        message: "Phone number format is invalid.",
                      );
                    }
                  }
                },
              ),
            );
          },
        ),
        onButtonTap: () {
          if (widget.isEdit!) {
            AppRouter.back();
          } else {
            AppRouter.push(SubscriptionPlanView(isPro: true));
          }
        },
        title: widget.isEdit!
            ? context.tr("edit_profile")
            : context.tr("create_profile"),
        showBottomButton: true,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          children: [
            Center(
              child: Consumer(
                builder: (context,ref, child) {
                  final data = ref.watch(authProvider.select((e)=>(e.imageUrl, e.uploadImageApiResponse, e.removeImageApiResponse)));

                  return ProfileImageChanger(
                    profileUrl: data.$1, onRemoveImage: () {  
                        ref.read(authProvider.notifier).removeImage(imageUrl: data.$1!);
                    }, apiResponse: data.$2,
                    onImageSelected: (file) {

                      ref.read(authProvider.notifier).uploadImage(file: file);
                    },
                   
                  );
                }
              ),
            ),
            20.ph,
            TextFormField(
              controller: nameTextController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                labelText: context.tr("name"),
                hintText: context.tr("name"),
              ),
            ),
            10.ph,
            TextFormField(
              readOnly: widget.isEdit ?? false,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: addressTextController,
              decoration: InputDecoration(
                labelText: context.tr("address"),
                hintText: context.tr("address"),
                // suffixIcon: Icon(
                //   Icons.check_circle_rounded,
                //   color: AppColors.secondaryColor,
                // ),
              ),
            ),
            10.ph,
            CustomPhoneTextfieldWidget(
              phoneNumberController: phoneTextController,
              initialCountryCode: initialCountryCode,
              onCountryChanged: (c) {
                setState(() {
                  initialCountryCode = c.code;
                });
              },
              onPhoneNumberChanged: (phone) {
                print(phone);
                // Handle phone number changes here
                // For example, update the controller or send to API
                // phoneTextController.text += phone.phoneNumber ?? '';
              },
            ),

            // TextFormField(
            //           controller: phoneTextController,
            //           onTapOutside: (event) {
            //   FocusScope.of(context).unfocus();
            // },
            //           keyboardType: TextInputType.phone,
            //           decoration: InputDecoration(

            //     labelText: "Phone Number",
            //     hintText: "Enter Phone Number"
            //   ),
            // ),
            //         10.ph,
            //         TextFormField(
            //           onTapOutside: (event) {
            //   FocusScope.of(context).unfocus();
            // },
            //           controller: emailTextController,
            //           readOnly: widget.isEdit ?? false,
            //           decoration: InputDecoration(
            //             labelText: "Email Address",
            //             hintText: "Enter Email",
            //             suffixIcon: Icon(Icons.check_circle_rounded, color: AppColors.secondaryColor,)
            //           ),
            //         ),
          ],
        ),
      ),
    );
  }
}
