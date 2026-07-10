
import '../../export_all.dart';
import '../../utils/legal_content.dart';
import '../../widget/legal_text_content_widget.dart';

class TermConditionsView extends StatelessWidget {
  const TermConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: context.tr("terms_conditions"),
      child: const LegalTextContentWidget(
        content: LegalContent.termsAndConditions,
      ),
    );
  }
}
