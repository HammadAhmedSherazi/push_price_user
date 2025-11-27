import 'package:push_price_user/utils/extension.dart';
import '../export_all.dart';

class AuthScreenTemplateWidget extends StatefulWidget {
  final String title;
  final List<Widget> childrens;
  final Widget? bottomWidget;
  final VoidCallback? onBackTap;

  const AuthScreenTemplateWidget({
    super.key,
    required this.title,
    required this.childrens,
    this.bottomWidget,
    this.onBackTap,
  });

  @override
  State<AuthScreenTemplateWidget> createState() =>
      _AuthScreenTemplateWidgetState();
}

class _AuthScreenTemplateWidgetState extends State<AuthScreenTemplateWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late AnimationController _controller;
  late Animation<Offset> _logoOffset;
  late Animation<double> _opacity;

  @override
  bool get wantKeepAlive => true; // Prevents rebuild on keyboard open

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoOffset = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required when using keep-alive

    return CustomScreenTemplate(
      onBackCall: widget.onBackTap,
      title: widget.title,
      showBottomButton: widget.bottomWidget != null,
      customBottomWidget: widget.bottomWidget,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.horizontalPadding,
          vertical: 20.r,
        ),
        children: [
          Center(
            child: AnimatedLogo(
              opacity: _opacity,
              offset: _logoOffset,
            ),
          ),
          30.ph,
          ...widget.childrens,
        ],
      ),
    );
  }
}

/// --------------------------------------------
///   LOGO ANIMATION WIDGET (Does NOT rebuild)
/// --------------------------------------------
class AnimatedLogo extends StatelessWidget {
  final Animation<Offset> offset;
  final Animation<double> opacity;

  const AnimatedLogo({
    super.key,
    required this.offset,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
  
    return SlideTransition(
      position: offset,
      child: FadeTransition(
        opacity: opacity,
        child: const AppLogoWidget(), // stays constant, avoids rebuild
      ),
    );
  }
}
