import '../export_all.dart';

class CustomBackWidget extends StatelessWidget {
  final VoidCallback ? onTap;
  const CustomBackWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (){
        AppRouter.back();
      },
      child: Container(
        // width: 24.r,
        // height: 24.r,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: 6.r,
          
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: Color(0xffEBF5FC)
        ),
        child: Icon(Icons.arrow_back_ios, color: AppColors.secondaryColor, size: 16.r,),
      ),
    );
  }
}