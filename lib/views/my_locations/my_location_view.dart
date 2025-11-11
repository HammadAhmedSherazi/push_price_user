import '../../export_all.dart';
import '../../utils/extension.dart';

class MyLocationView extends ConsumerStatefulWidget {
  const MyLocationView({super.key});

  @override
  ConsumerState<MyLocationView> createState() => _MyLocationViewState();
}

class _MyLocationViewState extends ConsumerState<MyLocationView> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      fetchLocationData();
    });
    
  }
  void fetchLocationData(){
    ref.read(geolocatorProvider.notifier).getAddresses();
  }
  @override
  Widget build(BuildContext context) {
    
    return CustomScreenTemplate(
      // showBottomButton: true,
      // customBottomWidget: GestureDetector(
      //   onTap: () => AppRouter.push(AddNewAddressView()),
      //   child: Row(
      //     spacing: 5,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Icon(Icons.add),
      //       Text("ADD NEW LOCATION", style: context.textStyle.displayMedium!.copyWith(
      //         color: Colors.white
      //       ),)
      //     ],
      //   ),
      // ),
      title: "My Locations",
      child: Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(geolocatorProvider.select((e)=>(e.getAddressesApiResponse, e.addresses)));
          final res = data.$1;
          final list = data.$2 ?? [];
          return AsyncStateHandler(
            status: res.status,
            dataList: list,
            itemBuilder: (context, index) {
              final address = list[index];
              return ListTile(
                horizontalTitleGap: 1.0,
                contentPadding: EdgeInsets.zero,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(Assets.locationIcon),
                ),
                title: Text(
                  address.label ?? 'Address ${index + 1}',
                  style: context.textStyle.headlineMedium,
                  maxLines: 1,
                ),
                subtitle: Text(
                  '${address.addressLine1}, ${address.city}',
                  style: context.textStyle.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => AppRouter.push(AddNewAddressView(addressToEdit: address)), // For edit
                      icon: Icon(Icons.edit, color: AppColors.secondaryColor),
                    ),
                    IconButton(
                      onPressed: () {}, // TODO: Implement delete
                      icon: Icon(Icons.delete, color: Color.fromRGBO(174, 27, 13, 1)),
                    ),
                  ],
                ),
                onTap: () => AppRouter.customback(times: 2),
              );
            },
            onRetry: () => fetchLocationData(),
          );
        }
      ),
    );
  }
}
