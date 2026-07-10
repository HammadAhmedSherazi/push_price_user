
import '../../export_all.dart';
import '../../utils/legal_content.dart';
import '../../widget/legal_text_content_widget.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: context.tr("privacy_policy"),
      child: const LegalTextContentWidget(
        content: LegalContent.privacyPolicy,
      ),
    );
  }
}
