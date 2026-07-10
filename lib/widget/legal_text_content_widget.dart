import '../export_all.dart';

class LegalTextContentWidget extends StatelessWidget {
  final String content;

  const LegalTextContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(context.pageHorizontalPadding),
      children: [
        SelectableText(
          content,
          style: context.textStyle.bodyMedium!.copyWith(
            height: 1.5,
            color: AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
