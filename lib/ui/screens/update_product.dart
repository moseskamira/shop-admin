import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:shop_owner_app/core/models/category_model.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_border.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_snackbar.dart';
import 'dart:io';
import '../../core/view_models/update_image_provider.dart';
import '../widgets/update_reusable_textField.dart';
import 'package:shop_owner_app/ui/widgets/image_preview.dart' as placeHolder;
import 'package:collection/collection.dart';

// ignore: must_be_immutable
class UpdateProductScreen extends StatefulWidget {
  ProductModel? singleProductDtaforUpdate;
  UpdateProductScreen({super.key, this.singleProductDtaforUpdate});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _categories = CategoryModel().getCategories();
  late final FocusNode _titleFocusNode;
  late final FocusNode _brandFocusNode;
  late final FocusNode _priceFocusNode;
  late final FocusNode _quantityFocusNode;
  late final FocusNode _categoryFocusNode;
  late final FocusNode _descriptionFocusNode;
  late final ProductModel _productModel;
  late bool _isPopular;
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  late ProductModel? _initialData;
  @override
  void initState() {
    super.initState();

    _titleFocusNode = FocusNode();
    _brandFocusNode = FocusNode();
    _priceFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
    _categoryFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _productModel = ProductModel();
    _nameController = TextEditingController();
    _brandController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _descriptionController = TextEditingController();
    setUpPreloadedData();

    Future.microtask(() {
      Provider.of<UpdateImageProvider>(context, listen: false).reset();
      ProductModel? data = widget.singleProductDtaforUpdate;
      Provider.of<UpdateImageProvider>(context, listen: false)
          .addAll(data!.imageUrls!);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
    _brandFocusNode.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _categoryFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    // Provider.of<UpdateImageProvider>(context, listen: false).reset();
  }

  setUpPreloadedData() {
    _initialData = widget.singleProductDtaforUpdate;
    ProductModel? data = widget.singleProductDtaforUpdate;
    if (data?.isPopular ?? true) {
      _isPopular = true;
    } else {
      _isPopular = false;
    }
    _nameController.text = data?.name.toString() ?? "";
    _brandController.text = data?.brand.toString() ?? "";
    _priceController.text = data?.price.toString() ?? "";
    _quantityController.text = data?.quantity.toString() ?? "";
    _descriptionController.text = data?.description.toString() ?? "";
    int index = 0;
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i].title == data?.category.toString()) {
        index = i;
        break;
      }
    }
    _productModel.category = _categories[index].title;
    //loading data..
  }

  bool _isFormChanged(BuildContext context) {
    return _nameController.text != _initialData?.name ||
        _brandController.text != _initialData?.brand ||
        _priceController.text != _initialData?.price.toString() ||
        _quantityController.text != _initialData?.quantity.toString() ||
        _descriptionController.text != _initialData?.description ||
        _isPopular != (_initialData?.isPopular ?? true) ||
        haveImagesChanged(context);
  }

  bool haveImagesChanged(BuildContext context) {
    final initialImageUrls = _initialData?.imageUrls ?? [];
    final updatedImageUrls =
        Provider.of<UpdateImageProvider>(context, listen: false)
            .images
            .map((image) => image.urlOfTheImage)
            .toList();

    // Use ListEquality to compare both length and content
    const listEquality = ListEquality();
    return !listEquality.equals(initialImageUrls, updatedImageUrls);
  }

  bool loadingOnUpload = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final uploadingPictureProvider = Provider.of<PicturesProvider>(context);

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, void result) async {
        if (didPop) {
          return;
        }
        final bool hasChanges = _isFormChanged(context);

        if (hasChanges) {
          final bool shouldPop =
              await MyAlertDialog.showDiscardDialog(context) ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: loadingOnUpload,
        progressIndicator: SpinKitFadingCircle(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.white : Colors.green,
              ),
            );
          },
        ),
        dismissible: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Update Product"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<UpdateImageProvider>(
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
                                            const placeHolder.ImagePreview(
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
                                                      imageList.addAll(
                                                          pickedImagePath);
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
                                      key: ValueKey(
                                          imageList.images[imageIndex]),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        decoration: index == 1
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
                                                imageList
                                                    .setThumbnail(imageIndex);
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
                                                        BorderRadius.circular(
                                                            20),
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

                          // all the fields
                          fields(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0)),
                          label: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 20.0,
                                letterSpacing: 3.0,
                                color: Colors.white),
                          ),
                          icon: const Icon(Icons.close,
                              size: 24, color: Colors.white),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0)),
                          label: const Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 20.0,
                                letterSpacing: 3.0,
                                color: Colors.white),
                          ),
                          icon: const Icon(Icons.save_as,
                              size: 24, color: Colors.white),
                          onPressed: () async {
                            final isValid = _formKey.currentState!.validate();
                            FocusScope.of(context).unfocus();
                            final imageProvider =
                                Provider.of<UpdateImageProvider>(context,
                                    listen: false);

                            if (isValid) {
                              setState(() {
                                loadingOnUpload = true;
                              });
                              _productModel.name =
                                  _nameController.text.toString();
                              _productModel.brand =
                                  _brandController.text.toString();

                              _productModel.description =
                                  _descriptionController.text.toString();
                              _productModel.isPopular = _isPopular;
                              _productModel.imageUrls =
                                  widget.singleProductDtaforUpdate?.imageUrls;
                              _productModel.price = double.tryParse(
                                      _priceController.text.toString()) ??
                                  0;

                              _productModel.quantity = int.tryParse(
                                      _quantityController.text.toString()) ??
                                  0;
                              _productModel.imageUrls = imageProvider.images
                                  .map((item) => item.urlOfTheImage)
                                  .toList();

                              if (imageProvider.newImagesToUpload.isNotEmpty) {
                                await uploadingPictureProvider
                                    .updatePictures(
                                        lengthOfImages:
                                            imageProvider.images.length,
                                        picturesList:
                                            imageProvider.newImagesToUpload,
                                        productsName: _productModel.name)
                                    .then((val) {
                                  _productModel.imageUrls =
                                      imageProvider.mergeAndRearrangeAsList(
                                          oldData: imageProvider.backedUpImages,
                                          recentUploads: val);
                                  setState(() {});
                                });
                              }

                              if (imageProvider.isDeletedPreviousImage) {
                                await uploadingPictureProvider.deletePictures(
                                    picturePaths: imageProvider
                                        .urlofThemimagesToDeleteFromStorage);
                              }

                              _productModel.id =
                                  widget.singleProductDtaforUpdate!.id;
                              productsProvider
                                  .updateProduct(_productModel,
                                      widget.singleProductDtaforUpdate!.id)
                                  .then((value) {
                                setState(() {
                                  loadingOnUpload = false;
                                });

                                MySnackBar().showSnackBar(
                                    'Updated Successfully', context,
                                    duration: const Duration(seconds: 2));
                                Navigator.of(context).pop();
                              });
                            } else {}
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name Section
        _sectionTitle('Name'),
        CustomTextField(
          maxLines: 4,
          controller: _nameController,
          focusNode: _titleFocusNode,
          hintText: 'Add product name...',
          validator: (value) => value!.isEmpty ? 'Required' : null,
          nextFocusNode: _brandFocusNode,
        ),

        /// Brand Section
        _sectionTitle('Brand'),
        CustomTextField(
          controller: _brandController,
          focusNode: _brandFocusNode,
          hintText: 'Add product brand...',
          validator: (value) => value!.isEmpty ? 'Required' : null,
          nextFocusNode: _priceFocusNode,
        ),

        /// Price Section
        _sectionTitle('Price'),
        CustomTextField(
          controller: _priceController,
          focusNode: _priceFocusNode,
          hintText: 'Add product price...',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a price";
            }
            if (double.tryParse(value) == null) {
              return "Please enter a valid price";
            }
            return null;
          },
          nextFocusNode: _quantityFocusNode,
        ),

        // Quantity Section
        _sectionTitle('Quantity'),

        CustomTextField(
          controller: _quantityController,
          focusNode: _quantityFocusNode,
          hintText: 'Add product quantity...',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a quantity";
            }
            if (int.tryParse(value) == null) {
              return "Please enter a valid integer";
            }
            return null;
          },
          nextFocusNode: _categoryFocusNode,
        ),

        // Category section
        _sectionTitle('Category'),
        DropdownButtonFormField(
          focusNode: _categoryFocusNode,
          onTap: () {
            FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
        //Gap(2.h),
        SizedBox(
          height: 2.h,
        ),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Is popular'),
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

        // Description Section
        _sectionTitle('Description'),
        const SizedBox(height: 10),

        CustomTextField(
          controller: _descriptionController,
          focusNode: _descriptionFocusNode,
          maxLines: 10,
          hintText: 'Add product description...',
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
      ],
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

/// Custom widget to show the preview of an image from the device memory or network
class ImagePreview extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;

  const ImagePreview({
    super.key,
    this.imagePath = '',
    this.width = 100,
    this.height = 100,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _isNetworkImage(String? path) {
    return path != null &&
        (path.startsWith('http://') || path.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Fixed height
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
        color: Colors.grey[200],
        image: DecorationImage(
          image: _isNetworkImage(widget.imagePath)
              ? CachedNetworkImageProvider(widget.imagePath)
              : FileImage(File(widget.imagePath)),
          fit: BoxFit.cover,
        ),
      ),

      // Show local file image
    );
  }
}
