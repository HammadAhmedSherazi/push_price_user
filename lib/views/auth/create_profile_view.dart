import 'package:intl_phone_number_input/intl_phone_number_input.dart' as ph ;
import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart' ;

class CreateProfileView extends ConsumerStatefulWidget {
  final bool? isEdit;
  const CreateProfileView({super.key, this.isEdit = false});

  @override
  ConsumerState<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends ConsumerState<CreateProfileView> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController employeeIdTextController =
      TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController addressTextController = TextEditingController();
  String profileImage = "",  isoCode = "US", dialCode = "+1";

  @override
  void initState() {
    // Future.microtask((){
    final user = ref.read(authProvider.select((e) => e.userData));
   Future.microtask((){
     ref.read(authProvider.notifier).imageUnset();
   });
    if (user != null) {
      final phone = PhoneNumber.parse(user.phoneNumber);
      isoCode = phone.isoCode.name;
      dialCode = phone.countryCode;
      nameTextController.text = widget.isEdit! ? user.fullName : "";
      employeeIdTextController.text = widget.isEdit! ? "123456789" : "";
      phoneTextController.text = widget.isEdit! ? phone.nsn : "";
      emailTextController.text = widget.isEdit! ? user.email : "";
      addressTextController.text = widget.isEdit! ? user.address : "";
      profileImage = user.profileImage ?? "";
    }
    // }
    // );

    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomScreenTemplate(
        customBottomWidget: Consumer(
          builder: (context, ref, child) {
            final response = ref.watch(
                  authProvider.select(
                    (e) => (e.completeProfileApiResponse.status, e.updateProfileApiResponse.status),
                  ),
                );
            final isLoad =
                 response.$1 ==
                Status.loading || response.$2 == Status.loading;
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
                      final isoCodeN = IsoCode.values.firstWhere(
                        (c) => c.name == isoCode.toUpperCase(),
                        orElse: () => IsoCode.US, // fallback
                      );

                      final parsed = PhoneNumber.parse(
                        phoneTextController.text,
                        destinationCountry: isoCodeN,
                      );

                      if (parsed.isValid()) {
                        if(widget.isEdit!){
                          UserDataModel userData = ref.watch(authProvider.select((e)=>e.userData!));
                          ref.read(authProvider.notifier).updateProfile(
                            showMessage: true,
                            userDataModel: userData.copyWith(

                            fullName: nameTextController.text,
                            address: addressTextController.text,
                            phoneNumber: parsed.international,
                            profileImage: profileImage
                          ));
                        }
                        else{
                          Map<String, dynamic> data = {
                          "full_name": nameTextController.text,
                          "phone_number": parsed.international,
                          "address": addressTextController.text,
                        };
                        profileImage =
                            ref.watch(authProvider.select((e) => e.imageUrl)) ??
                            "";
                        if (profileImage != "") {
                          data['profile_image'] = profileImage;
                        }
                        // print(data);
                        ref
                            .read(authProvider.notifier)
                            .completeProfile(profileData: data);
                        }
                        
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
                builder: (context, ref, child) {
                  final data = ref.watch(
                    authProvider.select(
                      (e) => (
                        e.imageUrl,
                        e.uploadImageApiResponse,
                        e.removeImageApiResponse,
                        e.userData?.profileImage
                      ),
                    ),
                  );
                  profileImage =  data.$1 != "" ? data.$1 ?? '': data.$4 ?? "";
                  return ProfileImageChanger(
                    profileUrl: profileImage,
                    onRemoveImage: () {
                      ref
                          .read(authProvider.notifier)
                          .removeImage(imageUrl: profileImage);
                    },
                    apiResponse: data.$2,
                    onImageSelected: (file) {
                      ref.read(authProvider.notifier).uploadImage(file: file);
                    },
                  );
                },
              ),
            ),
            20.ph,
            TextFormField(
              controller: nameTextController,
              validator: (value) => value?.validateUsername(),
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
            
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              validator: (value) => value?.validateGeneralField(fieldName: "Address", minStrLen: 10),
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
              initialValue: ph.PhoneNumber(phoneNumber: phoneTextController.text, isoCode: isoCode, dialCode: dialCode),
              
              onPhoneNumberChanged: (phone) {
                
                // initialCountryCode = phone.isoCode ?? "";
                isoCode = phone.isoCode ?? "";
                dialCode = phone.dialCode ?? "";
                print("${phone.phoneNumber}");
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
