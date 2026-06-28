import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (context, ref, child) {
          final response =
              ref.watch(authProvider.select((e) => e.getUserApiResponse));
          return AsyncStateHandler(
            status: response.status,
            dataList: const [1],
            itemBuilder: null,
            onRetry: () {},
            customSuccessWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    CustomAppBarWidget(
                      height: context.tabAppBarTitleHeight,
                      title: context.tr("profile"),
                      children: const [],
                    ),
                    Positioned(
                      bottom: -45.iw,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final image = ref.watch(
                            authProvider.select(
                              (e) => e.userData!.profileImage,
                            ),
                          );
                          return UserProfileWidget(
                            radius: 45,
                            imageUrl: image,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: -45.iw,
                      right: context.pageHorizontalPadding,
                      child: IconButton(
                        onPressed: () {
                          AppRouter.push(CreateProfileView(isEdit: true));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.secondaryColor,
                          size: 22.iw,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 45.iw + 20.ih),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.pageHorizontalPadding,
                    ).copyWith(bottom: context.scrollBottomPadding),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final user =
                            ref.watch(authProvider.select((e) => e.userData))!;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ProfileTitleWidget(
                              title: context.tr("name"),
                              value: user.fullName,
                            ),
                            ProfileTitleWidget(
                              title: context.tr("email"),
                              value: user.email,
                            ),
                            ProfileTitleWidget(
                              title: context.tr("phone_number"),
                              value: user.phoneNumber,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileTitleWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool showOutline;

  const ProfileTitleWidget({
    super.key,
    required this.title,
    required this.value,
    this.showOutline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.ih),
      padding: EdgeInsets.only(
        bottom: 10.ih,
        left: !showOutline ? 10.iw : 0.0,
      ),
      decoration: showOutline
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderColor),
              ),
            )
          : null,
      child: Row(
        children: [
          Text(title, style: context.textStyle.bodyMedium),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textStyle.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
