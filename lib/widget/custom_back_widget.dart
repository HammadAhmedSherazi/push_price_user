import '../export_all.dart';

class CustomBackWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final num? width;
  final num? height;

  const CustomBackWidget({super.key, this.onTap, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => AppRouter.back(),
      child: Container(
        width: (width ?? 32).iw,
        height: (height ?? 32).ih,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 6.iw),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.iw),
          color: const Color(0xffEBF5FC),
        ),
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.secondaryColor,
          size: 16.iw,
        ),
      ),
    );
  }
}
