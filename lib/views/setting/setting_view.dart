
import '../../export_all.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView> {
  bool notificationOn = false;
  bool travelModeOn = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).userData;
    notificationOn = user?.isEnableNotification ?? false;
  }

  List<MenuDataModel> _getMenuList(BuildContext context) {
    return [
      MenuDataModel(
        title: context.tr("push_notifications"),
        icon: Assets.notificationToggleIcon,
        onTap: () {},
      ),
      MenuDataModel(
        title: context.tr("change_language"),
        icon: Assets.languageIcon,
        onTap: () {
          AppRouter.push(ChangeLanguageView());
        },
      ),
      MenuDataModel(
        title: context.tr("privacy_policy"),
        icon: Assets.privacyIcon,
        onTap: () {
          AppRouter.push(PrivacyPolicyView());
        },
      ),
      MenuDataModel(
        title: context.tr("terms_conditions"),
        icon: Assets.termConditionIcon,
        onTap: () {
          AppRouter.push(TermConditionsView());
        },
      ),
      MenuDataModel(
        title: context.tr("about_app"),
        icon: Assets.aboutIcon,
        onTap: () {
          AppRouter.push(AboutAppView());
        },
      ),
      MenuDataModel(
        title: context.tr("delete_account"),
        icon: Assets.deleteIcon,
        onTap: () => _showDeleteAccountDialog(context),
      ),
    ];
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: dialogContext.isTablet ? 48 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF2F7FA),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogContext.dialogMaxWidth),
            child: Padding(
              padding: EdgeInsets.all(dialogContext.pageHorizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    dialogContext.tr('delete_account'),
                    style: dialogContext.textStyle.displayMedium?.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  10.ph,
                  Text(
                    dialogContext.tr('delete_account_confirmation'),
                    textAlign: TextAlign.center,
                    style: dialogContext.textStyle.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  30.ph,
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: CustomOutlineButtonWidget(
                          title: dialogContext.tr("cancel"),
                          compact: true,
                          onPressed: () => AppRouter.back(),
                        ),
                      ),
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            final isLoad = ref.watch(
                                  authProvider.select(
                                    (e) => e.deleteAccountApiResponse.status,
                                  ),
                                ) ==
                                Status.loading;
                            return CustomButtonWidget(
                              isLoad: isLoad,
                              color: const Color.fromRGBO(174, 27, 13, 1),
                              title: dialogContext.tr("delete"),
                              compact: true,
                              onPressed: isLoad
                                  ? null
                                  : () {
                                      ref
                                          .read(authProvider.notifier)
                                          .deleteAccount();
                                    },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuList = _getMenuList(context);
    return CustomScreenTemplate(
      title: context.tr("settings"),
      child: ListView.separated(
        padding: context.pagePadding,
        itemBuilder: (context, index) {
          final menu = menuList[index];
          final isNotification = menu.icon == Assets.notificationToggleIcon;
          final isTravelMode = menu.icon == Assets.travelModeIcon;
          final isDeleteAccount = menu.title == context.tr("delete_account");
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ListTile(
              tileColor: const Color.fromRGBO(251, 251, 251, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              horizontalTitleGap: 1.6,
              onTap: menu.onTap,
              leading: SvgPicture.asset(
                menu.icon,
                colorFilter: isDeleteAccount
                    ? const ColorFilter.mode(
                        Color.fromRGBO(174, 27, 13, 1),
                        BlendMode.srcIn,
                      )
                    : null,
              ),
              title: Text(
                menu.title,
                style: context.textStyle.bodyMedium?.copyWith(
                  color: isDeleteAccount
                      ? const Color.fromRGBO(174, 27, 13, 1)
                      : null,
                ),
              ),
              trailing: isNotification || isTravelMode
                  ? CustomSwitchWidget(
                      scale: 0.7,
                      value: isNotification ? notificationOn : travelModeOn,
                      onChanged: (val) {
                        final user = ref.read(authProvider).userData;
                        if (user == null) return;
                        setState(() {
                          if (isNotification) {
                            notificationOn = val;
                            ref.read(authProvider.notifier).updateProfile(
                                  userDataModel: user.copyWith(
                                    isEnableNotification: val,
                                  ),
                                );
                          } else {
                            travelModeOn = val;
                          }
                        });
                      },
                    )
                  : null,
            ),
          );
        },
        separatorBuilder: (context, index) => 10.ph,
        itemCount: menuList.length,
      ),
    );
  }
}
