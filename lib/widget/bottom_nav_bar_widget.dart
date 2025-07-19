import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class CustomBottomNavBarWidget extends StatelessWidget {
  
  const CustomBottomNavBarWidget({super.key, required this.items, required this.currentIndex, this.onTap});
  final List<BottomDataModel> items;
  final int currentIndex;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      width: double.infinity,
     padding: EdgeInsets.only(
      left: 20.r,
      right: 20.r,
      top: 15.r,
      bottom: 30.r
     ),
     
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
        border: Border.all(
          width: 1,
          color: AppColors.borderColor
        )
      ),
      child: Row(
        children:List.generate(items.length, (index) {
          final item = items[index];
          final Color selectColor = currentIndex == index? AppColors.primaryColor : AppColors.primaryColor.withValues(alpha: 0.6);
          return Expanded(
            child: InkWell(
              onTap: (){
                onTap?.call(index);
              },
              child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                  SvgPicture.asset(item.icon, colorFilter: ColorFilter.mode(selectColor, BlendMode.srcIn),),
                  Text(item.title, style: context.textStyle.displaySmall!.copyWith(
                    color: selectColor
                  ),)
                      
              ],
                      ),
            ),
          );
        }),
      ),
    );
  }
}

// class BottomNavBarItemWidget extends StatelessWidget {
//   const BottomNavBarItemWidget({
//     super.key,
//     required this.isSelected,
//     required this.onTap,
//     required this.image,
//   });

//   final bool isSelected;
//   final VoidCallback onTap;
//   final String image;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(
//               image,
//               fit: BoxFit.scaleDown,
//               height: 54,
//               width: 54,
//             ),
//             Text("Home",
//               style: TextStyle(
//                 color: isSelected ? AppColorTheme().primary : AppColorTheme().secondaryText,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }