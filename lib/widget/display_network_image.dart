import '../export_all.dart';

class DisplayNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const DisplayNetworkImage(
      {super.key,
      required this.imageUrl,
      this.height,
      this.width,
      this.errorWidget,
      this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    // Empty URL: show placeholder directly, avoid failed network call
    if (imageUrl.trim().isEmpty) {
      return _buildPlaceholder();
    }
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) =>
          errorWidget ??
          _buildPlaceholder(),
      placeholder: (context, url) =>
          loadingWidget ??
          _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        Assets.placeholderImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
