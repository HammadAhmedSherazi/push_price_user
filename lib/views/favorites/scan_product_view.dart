import 'package:push_price_user/providers/favourite_provider/favourite_provider.dart';
import 'package:push_price_user/views/favorites/add_new_favourite_view.dart';

import '../../export_all.dart';
import '../../utils/extension.dart';

class ScanProductView extends StatelessWidget {
  final bool isSignUp;
  final ProductDataModel product;
  const ScanProductView({
    super.key,
    required this.isSignUp,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: context.tr("barcode"),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: DisplayNetworkImage(
                  imageUrl: product.image,
                  width: 150.r,
                  height: 150.r,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.horizontalPadding,
                vertical: 30.r,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(242, 248, 254, 1),
              ),
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: context.textStyle.bodyMedium!.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('category'),
                        style: context.textStyle.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        product.category?.title ?? "",
                        style: context.textStyle.bodyMedium!,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: CustomPaint(painter: DottedLinePainter()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('price'),
                        style: context.textStyle.bodyMedium!.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "\$${product.price}",
                        style: context.textStyle.bodyMedium!,
                      ),
                    ],
                  ),
                  5.ph,
                  Consumer(
                    builder: (context, ref, child) {
                      return CustomButtonWidget(
                        title: context.tr("select_product"),
                        onPressed: () {
                          ref
                              .read(favouriteProvider.notifier)
                              .addProduct(product);

                          AppRouter.push(
                            AddNewFavouriteView(
                              isSignUp: isSignUp,
                              isScan: true,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DottedLinePainter({
    this.color = Colors.black,
    this.dashWidth = 3,
    this.dashSpace = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
