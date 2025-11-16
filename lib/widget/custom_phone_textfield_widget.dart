import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../export_all.dart' hide PhoneNumber;

class CustomPhoneTextfieldWidget extends StatefulWidget {
  final TextEditingController phoneNumberController;
  // final String initialCountryCode;
  final PhoneNumber? initialValue;
  
  final void Function(PhoneNumber)? onPhoneNumberChanged;

  const CustomPhoneTextfieldWidget({super.key, required this.phoneNumberController,   this.initialValue , required this.onPhoneNumberChanged});

  @override
  State<CustomPhoneTextfieldWidget> createState() => _CustomPhoneTextfieldWidgetState();
}

class _CustomPhoneTextfieldWidgetState extends State<CustomPhoneTextfieldWidget> {
  late String currentCountryCode;

  @override
  void initState() {
    super.initState();
    // currentCountryCode = widget.initialCountryCode;
  }

 

  // Country getCurrentCountry() {
  //   return countries.firstWhere(
  //     (c) => c.code == currentCountryCode,
  //     orElse: () => countries.firstWhere((c) => c.code == 'US', orElse: () => countries[0]),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return InternationalPhoneNumberInput(
    

    onInputChanged: widget.onPhoneNumberChanged,

    
    onInputValidated: (bool value) {
      // print(value);
    },
    
  keyboardAction : TextInputAction.done ,
    selectorConfig: SelectorConfig(

      // selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      useBottomSheetSafeArea: true,
      trailingSpace: false,

      setSelectorButtonAsPrefixIcon: true, // 👈 Key line here
    ),
    
    ignoreBlank: true,

    autoValidateMode: AutovalidateMode.disabled,
    selectorTextStyle: TextStyle(color: Colors.black),
    initialValue: widget.initialValue,

    textFieldController: widget.phoneNumberController,
    formatInput: true,
    // maxLength: getCurrentCountry().maxLength,
    validator: (value) => null, // Disable built-in validation error display
    // inputDecoration: InputDecoration(
    //   label: Text("Phone")
    // ),


    keyboardType: TextInputType.number,
    inputBorder: OutlineInputBorder(

    ),
    onSubmit: () {
      FocusScope.of(context).unfocus();
    },
    onSaved: (PhoneNumber number) {
      // print('On Saved: $number');
    },

  );
}

}