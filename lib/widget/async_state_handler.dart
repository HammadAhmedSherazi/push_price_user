

import 'package:push_price_user/utils/extension.dart';

import '../../../export_all.dart';


class AsyncStateHandler<T> extends StatelessWidget {
  final Status status;
  final List<T> dataList;
  final int? length;
  final Widget Function(BuildContext, int)? itemBuilder;
  final VoidCallback onRetry;
  final String? emptyMessage;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final Widget? loadingWidget;
  final Widget ? customSuccessWidget;
  final T? data;
  final Axis scrollDirection;
  final double ? boxHeight;

  const AsyncStateHandler({
    super.key,
    required this.status,
    required this.dataList,
    required this.itemBuilder,
    required this.onRetry,
    this.emptyMessage,
    this.boxHeight,
    this.scrollDirection = Axis.vertical,
    this.scrollController,
    this.padding,
    this.loadingWidget,
    this.data,
    this.customSuccessWidget,
    this.length
  });

  @override
  Widget build(BuildContext context) {
    if (status == Status.error && data == null) {
      return CustomErrorWidget(onPressed: onRetry);
    }

    if (status == Status.loading && data == null) {
      return loadingWidget ??( boxHeight != null ?Container(
        height: boxHeight,
        width: double.infinity,
        alignment: Alignment.center,
        child: CustomLoadingWidget(),
      ) : const CustomLoadingWidget());
    }

    if (status == Status.completed || status == Status.loadingMore ) {
      if (dataList.isEmpty ) {
        return boxHeight != null ? SizedBox(
          width: double.infinity,
          height: boxHeight,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShowEmptyItemDisplayWidget(message: emptyMessage ?? context.tr('no_item_found')),
          ],
        ),
        ) :  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShowEmptyItemDisplayWidget(message: emptyMessage ?? context.tr('no_item_found')),
          ],
        );
      }
      if(customSuccessWidget != null && itemBuilder == null){
        return customSuccessWidget!;
      }

      return  ListView.separated(
        scrollDirection: scrollDirection,
        controller: scrollController,
        // shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding ??  EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding, vertical: 10.r),
        itemBuilder: (context, index) {
          if (status == Status.loadingMore && index == dataList.length) {
            return const CustomLoadingWidget();
          } else {
            return itemBuilder!(context, index);
          }
        },
        separatorBuilder: (context, index) =>scrollDirection == Axis.vertical ? const SizedBox(height: 16): 10.pw,
        itemCount: status == Status.loadingMore ? dataList.length + 1 : length ?? dataList.length,
      );
    }

    return const SizedBox.shrink(); // Fallback
  }
}