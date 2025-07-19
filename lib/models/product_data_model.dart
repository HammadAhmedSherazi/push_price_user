class ProductDataModel {
  late final String title;
  late final String description;
  late final String image;
  
  ProductDataModel({required this.title, required this.description, required this.image});
}

class ProductSelectionDataModel extends ProductDataModel {
  final bool isSelect;

  ProductSelectionDataModel({
    required super.title,
    required super.description,
    required super.image,
    required this.isSelect,
  });

  ProductSelectionDataModel copyWith({
    String? title,
    String? description,
    String? image,
    bool? isSelect,
  }) {
    return ProductSelectionDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      isSelect: isSelect ?? this.isSelect,
    );
  }
}