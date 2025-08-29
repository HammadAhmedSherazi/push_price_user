import '../../utils/extension.dart';

import '../../export_all.dart';

class AddNewFavouriteView extends StatefulWidget {
  final bool isSignUp;
  final bool? isEdit;
  const AddNewFavouriteView({super.key, this.isEdit = false, required this.isSignUp});

  @override
  State<AddNewFavouriteView> createState() => _AddNewFavouriteViewState();
}

class _AddNewFavouriteViewState extends State<AddNewFavouriteView> {
  List<MyLocationDataModel> myLocation = [
    MyLocationDataModel(title: "Home", description: "ABC, Street Lorem Ipsum"),
    MyLocationDataModel(title: "Work", description: "ABC, Street Lorem Ipsum"),
  ];
  int selectIndex = -1; 
  bool selectTravelMode = false;
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      bottomButtonText: "add favorite",
      onButtonTap: (){
        if(widget.isSignUp){
          AppRouter.pushAndRemoveUntil(NavigationView());
        }
        else{
          if(!widget.isEdit!){
          AppRouter.customback(times: 4);
        }
        else{
          AppRouter.back();
        }
        }
        
      },
      title: widget.isEdit!? "save": "Add New Favorite", child: ListView(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.horizontalPadding
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.horizontalPadding
          ),
          child: ProductPriceTitleWidget(
            product: ProductDataModel(title: "ABC Product", description: "ABC Category", image: Assets.groceryBag, price: 99.99),
          ),
        ),
        20.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          child: Text("Distance", style: context.textStyle.displayMedium,),
        ),
        10.ph,
        CustomRangeSlider(),
         20.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          child: Text("My Location", style: context.textStyle.displayMedium,),
        ),
        10.ph,
        MyLocationTitleWidget(
          location: myLocation[0],
          isSelected: selectIndex == 0,
          onTap: () {
            setState(() {
            selectIndex = 0;
              
            });
          },
        ),
        Divider(
          color: Color.fromRGBO(116, 133, 160, 1),
        ),
        MyLocationTitleWidget(
          location: myLocation[1],
          isSelected:  selectIndex == 1,
          onTap: () {
            setState(() {
            selectIndex = 1;
              
            });
          },
        ),
        Divider(
          color: Color.fromRGBO(116, 133, 160, 1),
        ),
        10.ph,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
          child: Text("Travel Mode", style: context.textStyle.displayMedium,),
        ),
       10.ph,
        Padding(padding: EdgeInsets.symmetric(
          horizontal:  AppTheme.horizontalPadding
        ), child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(Assets.travelDiscountIcon, width: 20.r,),
            IconButton(
            visualDensity: VisualDensity(
              horizontal: -4.0
            ),
              onPressed: (){
                selectTravelMode = !selectTravelMode;
                setState(() {
                  
                });
              }, icon: Icon(!selectTravelMode? Icons.check_box_outline_blank : Icons.check_box, color: AppColors.secondaryColor,))
           
          ],
        ),)

      ],
    ));
  }
}

class MyLocationTitleWidget extends StatelessWidget {
  final MyLocationDataModel location;
  final VoidCallback onTap;
  final bool isSelected;
  const MyLocationTitleWidget({
    super.key,
    required this.location,
    required this.onTap,
    required this.isSelected
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: AppTheme.horizontalPadding,
        vertical: 5.r
      ),
      child: Row(
          children: [
            SvgPicture.asset(Assets.locationIcon),
            15.pw,
      
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location.title, style: context.textStyle.headlineMedium),
                  Text(
                    location.description,
                    style: context.textStyle.titleSmall,
                  ),
                ],
              ),
            ),
            IconButton(
            visualDensity: VisualDensity(
              horizontal: -4.0
            ),
              onPressed: onTap, icon: Icon(!isSelected? Icons.check_box_outline_blank : Icons.check_box, color: AppColors.secondaryColor,))
            ]),
    );
  }
}

class ProductPriceTitleWidget extends StatelessWidget {
  final ProductDataModel product;
  const ProductPriceTitleWidget({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.symmetric(
    horizontal: 15.r,
    vertical: 8.r
          ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Color.fromRGBO(243, 243, 243, 1)
        ),
        child: Row(
          spacing: 10,
          children: [
    Expanded(
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: context.textStyle.bodyMedium),
          Text("\$${product.price}", style: context.textStyle.bodyMedium!.copyWith(
            color: AppColors.secondaryColor
          )),
          Text(product.description, style: context.textStyle.bodySmall!.copyWith(
            color: AppColors.primaryTextColor.withValues(alpha: 0.7),
            
          )),
        
        ],
      ),
    ),
    Image.asset(product.image, width: 57.w, height: 70.h,),
    
    
           
          ],
        ),
                );
  }
}class CustomRangeSlider extends StatefulWidget {
  const CustomRangeSlider({super.key});

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  RangeValues _range = const RangeValues(0, 17);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.r
      ),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              
              activeTrackColor: AppColors.secondaryColor,
              inactiveTrackColor: Colors.teal.shade100,
              thumbColor: AppColors.secondaryColor,
            
              overlayColor: AppColors.secondaryColor.withValues(alpha: 0.2),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 4,
                pressedElevation: 8,
                
              ),
              
              rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            ),
            
            child: RangeSlider(
              values: _range,
              min: 0,
              max: 20,
              // divisions: 20,
              
              onChanged: (values) {
                setState(() => _range = values);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("0m", style: context.textStyle.bodyMedium!.copyWith(
                  color: AppColors.secondaryColor
                )),
                Text("${_range.end.toInt()}m", style: context.textStyle.bodyMedium!.copyWith(
                  color: AppColors.secondaryColor
                )),
                Text("20m", style: context.textStyle.bodyMedium!.copyWith(
                  color: AppColors.secondaryColor
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class MyLocationDataModel {
  final String title;
  final String description;


  MyLocationDataModel({
    required this.title,
    required this.description,
    
  });

  MyLocationDataModel copyWith({
    String? title,
    String? description,
    // bool? isSelect,
  }) {
    return MyLocationDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      // isSelect: isSelect ?? this.isSelect,
    );
  }
}
