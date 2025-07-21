import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class HelpFeedbackView extends StatefulWidget {
  const HelpFeedbackView({super.key});

  @override
  State<HelpFeedbackView> createState() => _HelpFeedbackViewState();
}

class _HelpFeedbackViewState extends State<HelpFeedbackView> {
  void showThankYouDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.teal),
            20.ph,
            Text(
              "Thank You",
              style: context.textStyle.displayMedium!.copyWith(
                fontSize: 18.sp,
                color: AppColors.secondaryColor
              ),
            ),
            12.ph,
            Text(
              "Your feedback has been submitted successfully!",
              textAlign: TextAlign.center,
              style: context.textStyle.bodyMedium!.copyWith(
                color: const Color.fromARGB(255, 121, 121, 121)
              ),
            ),
            24.ph,
            CustomButtonWidget(title: "back to home", onPressed: (){
              AppRouter.customback(times: 3);
            })
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      bottomButtonText: "submit",
      onButtonTap: (){
        showThankYouDialog(context);
      },
      title: "Help & Feedback", child: ListView(
      padding: EdgeInsets.all(AppTheme.horizontalPadding),
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: "Subject",
            hintText: "Enter Subject"
          ),
        ),
        10.ph,
        TextFormField(
          maxLines: 6,
          minLines: 6,
          decoration: InputDecoration(
            labelText: "Description",
            hintText: "Type your message here...."
          ),
        ),
      ],
    ));
  }
}