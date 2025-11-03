import 'dart:io';

import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class ProfileImageChanger extends StatefulWidget {
  final String? profileUrl;
  final ApiResponse  apiResponse;
  final void Function(File file)? onImageSelected;
  final void Function() onRemoveImage;

  const ProfileImageChanger({super.key, this.onImageSelected, this.profileUrl, required this.onRemoveImage, required this.apiResponse});

  @override
  State<ProfileImageChanger> createState() => _ProfileImageChangerState();
}

class _ProfileImageChangerState extends State<ProfileImageChanger> {
  File? _selectedImage;

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);

  //   if (picked != null) {
  //     final imageFile = File(picked.path);
  //     setState(() {
  //       _selectedImage = imageFile;
  //     });
  //     widget.onImageSelected?.call(imageFile);
  //   }
  // }
  Future<void> _pickImage() async {
    final picker = ImagePicker();

    // Show choice dialog
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppTheme.horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a photo'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                if((widget.profileUrl != null  || _selectedImage != null) && widget.profileUrl != "")...[
                  ListTile(
                  
                  leading: const Icon(Icons.delete, color: Colors.red,),
                  title:  Text('Remove profile picture', style: context.textStyle.displayMedium!.copyWith(
                    color: Colors.red
                  ),),
                  onTap: () {
                    setState(() {
                     
                      _selectedImage = null;
                    });
                    AppRouter.back();
                   
                    widget.onRemoveImage();
                  },
                ),
                ]
              ],
            ),
          ),
        );
      },
    );

    // If user canceled dialog
    if (source == null) return;

    // Pick image from selected source
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final imageFile = File(picked.path);
      // Compress the image
      final compressedFile = await Helper.compressImage(imageFile);
      if (compressedFile != null) {
        setState(() {
          _selectedImage = compressedFile;
          
        });
        widget.onImageSelected?.call(compressedFile);
      } else {
        // Handle compression failure, e.g., show a message
        if(!context.mounted) return;
        Helper.showMessage(context, message: 'Failed to compress image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [


      if(widget.apiResponse.status == Status.completed || widget.apiResponse.status == Status.error || widget.apiResponse.status == Status.undertermined)...[
          UserProfileWidget(radius: 50.r, imageUrl: widget.profileUrl ?? ""),
      ],
      // if()...[
      //   UserProfileWidget(radius: 50.r, imageUrl:  widget.profileUrl ?? "")
      // ],
      if(widget.apiResponse.status == Status.loading)...[
        Container(
          height: 108.r,
          width: 108.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 5,
              color: AppColors.borderColor,
            ),
            color: AppColors.secondaryColor,
            image:  DecorationImage(
              fit: BoxFit.cover,
              
              image: _selectedImage != null? FileImage(_selectedImage!) as ImageProvider : AssetImage(Assets.userAvatar)
                     ,
            ) ,
          ),
          child: CustomLoadingWidget() ,
          
        )
      ],
        
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
              width: 2,
              color: AppColors.borderColor,
            ),
              ),
              
              child:  Icon(Icons.camera_alt, color: AppColors.secondaryColor, size: 25.r,),
            ),
          ),
        ),
      ],
    );
  }
}
