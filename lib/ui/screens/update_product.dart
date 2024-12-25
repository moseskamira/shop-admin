import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shop_owner_app/core/models/category_model.dart';
import 'package:shop_owner_app/core/models/product_model.dart';
import 'package:shop_owner_app/core/view_models/products_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_border.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_snackbar.dart';
import 'package:shop_owner_app/ui/widgets/authenticate.dart';
import 'dart:io';
import '../../core/view_models/update_image_provider.dart';
import '../widgets/update_reusable_textField.dart';
import 'package:shop_owner_app/ui/widgets/image_preview.dart' as placeHolder;

// ignore: must_be_immutable
class UpdateProductScreen extends StatefulWidget {
  ProductModel? singleProductDtaforUpdate;
  UpdateProductScreen({super.key, this.singleProductDtaforUpdate});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

/// on update checking the changes in pictures list then taking actions based on that...
///

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
  late final TextEditingController productNameController;
  late final TextEditingController productBrandController;
  late final TextEditingController productPriceEditingController;
  late final TextEditingController productQuantityEditingController;
  late final TextEditingController productDescriptionEditingController;
  final _formKey = GlobalKey<FormState>();
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
    productNameController = TextEditingController();
    productBrandController = TextEditingController();
    productPriceEditingController = TextEditingController();
    productQuantityEditingController = TextEditingController();
    productDescriptionEditingController = TextEditingController();
    setUpPreloadedData();
    Future.microtask(() {
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
    productNameController.dispose();
    productBrandController.dispose();
    productPriceEditingController.dispose();
    productQuantityEditingController.dispose();
    productDescriptionEditingController.dispose();
  }

  setUpPreloadedData() {
    ProductModel? data = widget.singleProductDtaforUpdate;
    if (data?.isPopular ?? true) {
      _isPopular = true;
    } else {
      _isPopular = false;
    }
    productNameController.text = data?.name.toString() ?? "";
    productBrandController.text = data?.brand.toString() ?? "";
    productPriceEditingController.text = data?.price.toString() ?? "";
    productQuantityEditingController.text = data?.quantity.toString() ?? "";
    productDescriptionEditingController.text =
        data?.description.toString() ?? "";
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

  List<String> imageList = [
    "",
  ];
  List<String> imageChosenForASingleProduct = [];
  bool loadingOnUpload = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final uploadingPictureProvider = Provider.of<PicturesProvider>(context);

    return Authenticate(
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
                          /// image section
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imageList.length,
                                      itemBuilder: (context, index) {
                                        return index == 0
                                            ? Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Stack(
                                                    children: [
                                                      ImagePreview(
                                                        imagePath:
                                                            imageList[index],
                                                        height: 190,
                                                        width: 190,
                                                      ),
                                                      Positioned(
                                                        top: 80,
                                                        left: 75,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            final pickedImagePath =
                                                                await MyAlertDialog
                                                                    .imagePicker(
                                                                        context);
                                                            setState(() {
                                                              pickedImagePath !=
                                                                      null
                                                                  ? imageList.add(
                                                                      pickedImagePath)
                                                                  : null;
                                                              MySnackBar().showSnackBar(
                                                                  'New picture of the product is added',
                                                                  context,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              2));
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.add_circle,
                                                            size: 30,
                                                            color:
                                                                Colors.black45,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Stack(
                                                  children: [
                                                    ImagePreview(
                                                      imagePath:
                                                          imageList[index],
                                                      height: 190,
                                                      width: 190,
                                                    ),
                                                    Positioned(
                                                      top: 15,
                                                      right: 5,
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            imageList.remove(
                                                                imageList[
                                                                    index]);
                                                            MySnackBar().showSnackBar(
                                                                'Picture of the product is removed',
                                                                context,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2));
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black45,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: const Center(
                                                              child: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 80,
                                                      left: 75,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          final pickedImagePath =
                                                              await MyAlertDialog
                                                                  .imagePicker(
                                                                      context);
                                                          setState(() {
                                                            if (pickedImagePath !=
                                                                null) {
                                                              imageList.remove(
                                                                  imageList[
                                                                      index]);
                                                              imageList.add(
                                                                  pickedImagePath);
                                                              MySnackBar().showSnackBar(
                                                                  'Picture of the product is replaced',
                                                                  context,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              2));
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black45,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: const Center(
                                                              child: Icon(
                                                            Icons
                                                                .image_search_rounded,
                                                            color: Colors.white,
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      }),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget
                                          .singleProductDtaforUpdate
                                          ?.imageUrls
                                          ?.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 190,
                                                width: 190,
                                                decoration: BoxDecoration(
                                                  // radius circular depend on your requirement
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    // image url your network image url
                                                    image: NetworkImage(
                                                      widget.singleProductDtaforUpdate
                                                                  ?.imageUrls?[
                                                              index] ??
                                                          "",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 15,
                                                right: 5,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      widget
                                                          .singleProductDtaforUpdate
                                                          ?.imageUrls
                                                          ?.remove(widget
                                                              .singleProductDtaforUpdate
                                                              ?.imageUrls?[index]);
                                                      MySnackBar().showSnackBar(
                                                          'Picture of the product is removed',
                                                          context,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2));
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black45,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: const Center(
                                                        child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),

                          Consumer<UpdateImageProvider>(
                            builder: (context, imageList, child) {
                              return GridView.builder(
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
                                    // "Add Image" widget
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                          const  placeHolder.ImagePreview(
                                              imagePath:
                                                  '', // Empty or default image
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
                                    // Display actual images
                                    final imageIndex = index -
                                        1; // Adjust index due to "Add Image" widget
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        decoration: imageList
                                                .images[imageIndex].isThumbNail
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
                                            InkWell(
                                              onTap: () async {
                                                final pickedImagePath =
                                                    await MyAlertDialog
                                                        .imagePicker(context);

                                                if (pickedImagePath != null) {
                                                  imageList.replaceImage(
                                                      imageIndex,
                                                      pickedImagePath);
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

                            if (isValid) {
                              setState(() {
                                loadingOnUpload = true;
                              });
                              _productModel.name =
                                  productNameController.text.toString();
                              _productModel.brand =
                                  productBrandController.text.toString();

                              _productModel.description =
                                  productDescriptionEditingController.text
                                      .toString();
                              _productModel.isPopular = _isPopular;
                              _productModel.imageUrls =
                                  widget.singleProductDtaforUpdate?.imageUrls;
                              _productModel.price = double.tryParse(
                                      productPriceEditingController.text
                                          .toString()) ??
                                  0;

                              _productModel.quantity = int.tryParse(
                                      productQuantityEditingController.text
                                          .toString()) ??
                                  0;

                              if (imageList.length <= 1) {
                              } else {
                                for (int i = 1; i < imageList.length; i++) {
                                  imageChosenForASingleProduct
                                      .add(imageList[i]);
                                  setState(() {});
                                }

                                var listOfImageUrlLinks =
                                    await uploadingPictureProvider
                                        .uploadPictures(
                                            picturesList:
                                                imageChosenForASingleProduct,
                                            productsName: _productModel.name);

                                setState(() {
                                  _productModel.imageUrls
                                      ?.addAll(listOfImageUrlLinks);
                                });
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
          controller: productNameController,
          focusNode: _titleFocusNode,
          hintText: 'Add product name...',
          validator: (value) => value!.isEmpty ? 'Required' : null,
          nextFocusNode: _brandFocusNode,
        ),

        /// Brand Section
        _sectionTitle('Brand'),
        CustomTextField(
          controller: productBrandController,
          focusNode: _brandFocusNode,
          hintText: 'Add product brand...',
          validator: (value) => value!.isEmpty ? 'Required' : null,
          nextFocusNode: _priceFocusNode,
        ),

        /// Price Section
        _sectionTitle('Price'),
        CustomTextField(
          controller: productPriceEditingController,
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
        ),

        // Quantity Section
        _sectionTitle('Quantity'),

        CustomTextField(
          controller: productQuantityEditingController,
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
          controller: productDescriptionEditingController,
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
              ? CachedNetworkImageProvider(widget.imagePath!)
              : FileImage(File(widget.imagePath!)),
          fit: BoxFit.cover,
        ),
      ),

      // Show local file image
    );
  }
}
