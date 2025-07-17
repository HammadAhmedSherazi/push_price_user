import 'package:push_price_user/utils/extension.dart';
import '../../export_all.dart';

class TutorialView extends StatefulWidget {
  const TutorialView({super.key});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      bottomButtonText: "Next",
      onButtonTap: (){
        AppRouter.push(LoginView());
      },
      title: "Tutorial", child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: context.screenheight * 0.37,
            decoration: BoxDecoration(
              color: Color(0xff353535)
            ),
          ),
          Padding(padding: EdgeInsetsGeometry.all(20), child: Text("Lorem ipsum dolor sit amet consectetur adipiscing elit odio, mattis quam tortor taciti aenean luctus nullam enim, dui praesent ad dapibus tempus natoque a. Rh", textAlign: TextAlign.center ,style: context.textStyle.titleMedium ,),)
        ],
      ));
  }
}