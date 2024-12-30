import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/product_upload_image_provider.dart';
import 'package:shop_owner_app/core/models/category_model.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_border.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_snackbar.dart';
import 'package:shop_owner_app/ui/widgets/image_preview.dart';
import 'package:uuid/uuid.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _categories = CategoryModel().getCategories();
  late final FocusNode _brandFocusNode;
  late final FocusNode _priceFocusNode;
  late final FocusNode _quantityFocusNode;
  late final FocusNode _categoryFocusNode;
  late final FocusNode _descriptionFocusNode;
  late final ProductModel _productModel = ProductModel();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productModel.category = _categories[0].title;
    _brandFocusNode = FocusNode();
    _priceFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
    _categoryFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _brandFocusNode.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _categoryFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();
    final uploadingPictureProvider =
        Provider.of<PicturesProvider>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    final imageList =
        Provider.of<ImageListProductUpload>(context, listen: false);
    if (imageList.images.length == 1) {
      MySnackBar().showSnackBar('Please select at least one image', context,
          duration: const Duration(seconds: 2));
    } else if (isValid) {
      setState(() => _isLoading = true);
      List<String> images = [];

      await uploadingPictureProvider
          .uploadPictures(
              lengthOfImages: imageList.images.length,
              picturesList: imageList.images,
              productsName: _productModel.name)
          .then((img) {
        for (int i = 0; i < img.length; i++) {
          images.add(img[i].urlOfTheImage);
        }
      });

      setState(() {
        _productModel.imageUrls = images;
        _productModel.isPopular = _isPopular;
      });

      _formKey.currentState!.save();
      _productModel.id = const Uuid().v4();
      final productProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      await productProvider.addProduct(_productModel).then((_) {
        MySnackBar().showSnackBar('Success', context);
        setState(() {
          _productModel.imageUrls?.clear();
          _formKey.currentState?.reset();
          imageList.clear();
        });
      }).catchError((error) {
        MyAlertDialog.error(context, error.message);
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }

  bool _isPopular = false;

  @override
  Widget build(BuildContext context) {
    //   final imageList = Provider.of<ImageList>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload New Product"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ImageListProductUpload>(
                        builder: (context, imageList, child) {
                          return ReorderableGridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            shrinkWrap: true,
                            itemCount: imageList.images.isEmpty
                                ? 1
                                : imageList.images.length +
                                    1, // +1 for the "Add Image" widget
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Center(
                                  key: const ValueKey('add_image'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const ImagePreview(
                                          imagePath: '',
                                          height: 50,
                                          width: 50,
                                        ),
                                        Center(
                                          child: InkWell(
                                            onTap: () async {
                                              final pickedImagePath =
                                                  await MyAlertDialog
                                                      .imagePicker(context);

                                              if (pickedImagePath != null) {
                                                if (pickedImagePath
                                                    is List<String>) {
                                                  imageList
                                                      .addAll(pickedImagePath);
                                                } else if (pickedImagePath
                                                    is String) {
                                                  imageList
                                                      .add(pickedImagePath);
                                                }
                                                MySnackBar().showSnackBar(
                                                  'New picture of the product is added',
                                                  context,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                );
                                              }
                                            },
                                            child: const Icon(
                                              Icons.add_circle,
                                              size: 30,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                final imageIndex = index - 1;
                                return Padding(
                                  key: ValueKey(imageList.images[imageIndex]),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    decoration:
                                        imageList.images[imageIndex].isThumbNail
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 4),
                                              )
                                            : null,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            imageList.setThumbnail(imageIndex);
                                          },
                                          child: ImagePreview(
                                            imagePath: imageList
                                                .images[imageIndex]
                                                .urlOfTheImage,
                                            height: 190,
                                            width: 190,
                                          ),
                                        ),
                                        Positioned(
                                          top: 15,
                                          right: 5,
                                          child: InkWell(
                                            onTap: () {
                                              imageList.remove(imageIndex);
                                            },
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            final pickedImagePath =
                                                await MyAlertDialog.imagePicker(
                                                    context);

                                            if (pickedImagePath != null) {
                                              imageList.replaceImage(
                                                  imageIndex, pickedImagePath);
                                            }
                                          },
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.image_search_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            onReorder: (oldIndex, newIndex) {
                              imageList.reorderImages(
                                  oldIndex - 1, newIndex - 1);
                            },
                          );
                        },
                      ),

                      // Name Section
                      _sectionTitle('Name'),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                        decoration: InputDecoration(
                          hintText: 'Add product name...',
                          enabledBorder: MyBorder.underlineInputBorder(context),
                        ),
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_brandFocusNode),
                        onSaved: (value) => _productModel.name = value!,
                      ),

                      // Brand Section
                      _sectionTitle('Brand'),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        focusNode: _brandFocusNode,
                        validator: (value) =>
                            value!.isEmpty ? 'Requiered' : null,
                        decoration: InputDecoration(
                          hintText: 'Add product brand...',
                          enabledBorder: MyBorder.underlineInputBorder(context),
                        ),
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (value) => _productModel.brand = value!,
                      ),

                      // Price Section
                      _sectionTitle('Price'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        // ],
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                        decoration: InputDecoration(
                          hintText: 'Add product price...',
                          enabledBorder: MyBorder.underlineInputBorder(context),
                        ),
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_quantityFocusNode),
                        onSaved: (value) =>
                            _productModel.price = double.parse(value!),
                      ),

                      // Quantity Section
                      _sectionTitle('Quantity'),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _quantityFocusNode,
                        validator: (value) =>
                            value!.isEmpty ? 'Requiered' : null,
                        decoration: InputDecoration(
                          hintText: 'Add product quantity...',
                          enabledBorder: MyBorder.underlineInputBorder(context),
                        ),
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_categoryFocusNode),
                        onSaved: (value) =>
                            _productModel.quantity = int.parse(value!),
                      ),

                      // Category section
                      _sectionTitle('Category'),
                      DropdownButtonFormField(
                        focusNode: _categoryFocusNode,
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        items: _categories
                            .map(
                              (category) => DropdownMenuItem<String>(
                                value: category.title,
                                child: Text(category.title),
                              ),
                            )
                            .toList(),
                        value: _productModel.category,
                        onChanged: (String? value) {
                          setState(() {
                            _productModel.category = value.toString();
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: MyBorder.underlineInputBorder(context),
                        ),
                      ),

                      // Description Section
                      _sectionTitle('Description'),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        focusNode: _descriptionFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Add product description...',
                          border: const OutlineInputBorder(),
                          enabledBorder: MyBorder.outlineInputBorder(context),
                        ),
                        onSaved: (value) => _productModel.description = value!,
                      ),
                    ],
                  ),
                ),
              ),
              // Is Popular section Section

              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Is popular',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      value: _isPopular,
                      onChanged: (bool value) {
                        setState(() {
                          _isPopular = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Upload Product Button
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: _submitForm,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Colors.white,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 14),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
