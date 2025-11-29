import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class OverlappingImages extends StatelessWidget {
  final List<String> images;

  const OverlappingImages({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final aboveTwo = images.length > 2;
    return SizedBox(
      width: aboveTwo ? 103.r : 73.r,
      height: 80.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(
            aboveTwo ? 2 : images.length,
            (index) => ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: DisplayNetworkImage(
                imageUrl: images[index],
                width: aboveTwo ? 30.r : 35.r,
                height: aboveTwo ? 30.r : 35.r,
              ),
            ),
          ),

          // Show the +x only if more than 2 images
          if (aboveTwo)
            Container(
              width: 30.r,
              height: 30.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.secondaryColor,
              ),
              child: Text(
                "+${images.length - 2}",
                style: context.textStyle.bodySmall!.copyWith(
                  color: Colors.white
                ), // your text style
              ),
            ),
        ],
      ),
    );
  }
}
