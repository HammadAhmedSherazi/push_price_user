
import '../export_all.dart';


class CustomButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height, width,radius;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final bool isLoad;
  final BoxBorder? border;
  final bool? isElevated;
  final bool? isEnabled;
  final bool fitContent;
  final bool compact;

  const CustomButtonWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      this.height,
      this.isElevated = false,
      this.isEnabled = true,
      this.color,
      this.textColor,
      this.child,
      this.isLoad = false,
      this.radius,
      this.border,
      this.width,
      this.fitContent = false,
      this.compact = false});

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.primaryColor;
    final labelColor = textColor ?? Colors.white;
    final fontSize = 14.sp;
    final labelStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: labelColor,
      letterSpacing: 0.5,
    );

    return SizedBox(
      width: fitContent ? width : (width ?? double.infinity),
      height: height ?? 40.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(radius ?? 32.r),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: isElevated == true ? 2 : 0,
            backgroundColor: buttonColor,
            foregroundColor: labelColor,
            disabledBackgroundColor: buttonColor,
            disabledForegroundColor: labelColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 32.r),
            ),
            textStyle: labelStyle,
            padding: compact
                ? EdgeInsets.symmetric(horizontal: 12.iw, vertical: 8.ih)
                : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          ),
          onPressed: !isLoad ? onPressed : null,
          child: isLoad
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(labelColor),
                  ),
                )
              : child ??
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: labelStyle,
                  ),
        ),
      ),
    );
  }
}

class CustomOutlineButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height, width, radius;
  final Color? color;
  final Color? textColor;
  final Widget? child;
  final Color? outlineColor;
  final bool isLoad;
  final bool compact;

  const CustomOutlineButtonWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      this.height,
      this.color,
      this.textColor,
      this.child,
      this.outlineColor,
      this.isLoad = false,
      this.radius,
      this.width,
      this.compact = false});

  @override
  Widget build(BuildContext context) {
    final labelColor = textColor ?? AppColors.primaryTextColor;
    final fontSize = 14.sp;
    final labelStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: labelColor,
      letterSpacing: 0.5,
    );

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 40.h,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              elevation: 0,
              alignment: Alignment.center,
              side: BorderSide(color: outlineColor ?? AppColors.borderColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 32.r)),
              backgroundColor: color ?? Colors.transparent,
              foregroundColor: labelColor,
              textStyle: labelStyle,
              padding: compact
                  ? EdgeInsets.symmetric(horizontal: 12.iw, vertical: 8.ih)
                  : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)),
          onPressed: !isLoad ? onPressed : null,
          child: isLoad
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                        outlineColor ?? AppColors.primaryColor),
                  ),
                )
              : child ??
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: labelStyle,
                  )),
    );
  }
}
