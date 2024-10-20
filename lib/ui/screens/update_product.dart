import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:shop_owner_app/ui/widgets/image_preview.dart';

class UpdateProductScreen extends StatefulWidget {
  ProductModel? singleProductDtaforUpdate;
  UpdateProductScreen({Key? key, this.singleProductDtaforUpdate})
      : super(key: key);

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  var _categories = CategoryModel().getCategories();
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final ProductModel _productModel = ProductModel();
  bool _isLoading = false;
  bool _isPopular = false;
  TextEditingController productNameEditingController = TextEditingController();
  TextEditingController productBrandEditingController = TextEditingController();
  TextEditingController productPriceEditingController = TextEditingController();
  TextEditingController productQuantityEditingController =
      TextEditingController();
  TextEditingController productDescriptionEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    setUpPreloadedData();
  }

  @override
  void dispose() {
    super.dispose();
    _brandFocusNode.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _categoryFocusNode.dispose();
    _descriptionFocusNode.dispose();
    productNameEditingController.dispose();
    productBrandEditingController.dispose();
    productPriceEditingController.dispose();
    productQuantityEditingController.dispose();
    productDescriptionEditingController.dispose();
  }

  setUpPreloadedData() {
    if (widget.singleProductDtaforUpdate?.isPopular ?? true) {
      _isPopular = true;
    } else {
      _isPopular = false;
    }
    productNameEditingController.text =
        widget.singleProductDtaforUpdate?.name.toString() ?? "";
    productBrandEditingController.text =
        widget.singleProductDtaforUpdate?.brand.toString() ?? "";
    productPriceEditingController.text =
        widget.singleProductDtaforUpdate?.price.toString() ?? "";
    productQuantityEditingController.text =
        widget.singleProductDtaforUpdate?.quantity.toString() ?? "";
    productDescriptionEditingController.text =
        widget.singleProductDtaforUpdate?.description.toString() ?? "";
    int index = 0;
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i].title ==
          widget.singleProductDtaforUpdate?.category.toString()) {
        index = i;
        break;
      }
    }
    _productModel.category = _categories[index].title;
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

                                                    ///code for showing thumbnail image
                                                    // index==1?  Positioned(
                                                    //     top: 15,
                                                    //     left: 5,
                                                    //     child: Container(height: 25,
                                                    //         width: 25,child: Icon(Icons.thumb_up_alt_outlined, color: Colors.red,))):Container(),
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
                                                          //  _productModel.imageUrl = _pickedImagePath;
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
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Stack(
                                                children: [
                                                  ImagePreview(
                                                    imagePath: imageList[index],
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
                                                              imageList[index]);
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
                                                            color:
                                                                Colors.black45,
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
                                                            color:
                                                                Colors.black45,
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
                                    itemCount: widget.singleProductDtaforUpdate
                                        ?.imageUrls?.length,
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
                                                          BorderRadius.circular(
                                                              20)),
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

                        // Name Section
                        _sectionTitle('Name'),
                        TextField(
                          controller: productNameEditingController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Add product name...',
                            enabledBorder:
                                MyBorder.underlineInputBorder(context),
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_brandFocusNode),
                        ),

                        /// Brand Section
                        _sectionTitle('Brand'),
                        TextField(
                          controller: productBrandEditingController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          focusNode: _brandFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Add product brand...',
                            enabledBorder:
                                MyBorder.underlineInputBorder(context),
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_priceFocusNode),
                        ),

                        /// Price Section
                        _sectionTitle('Price'),
                        TextField(
                          controller: productPriceEditingController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          focusNode: _priceFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Add product price...',
                            enabledBorder:
                                MyBorder.underlineInputBorder(context),
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_quantityFocusNode),
                        ),

                        // Quantity Section
                        _sectionTitle('Quantity'),
                        TextField(
                          controller: productQuantityEditingController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          focusNode: _quantityFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Add product quantity...',
                            enabledBorder:
                                MyBorder.underlineInputBorder(context),
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_categoryFocusNode),
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
                                  child: Text(category.title),
                                  value: category.title,
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
                            enabledBorder:
                                MyBorder.underlineInputBorder(context),
                          ),
                        ),
                        //Gap(2.h),
                        SizedBox(height: 2.h,),
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
                        TextField(
                          controller: productDescriptionEditingController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                          focusNode: _descriptionFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Add product description...',
                            border: const OutlineInputBorder(),
                            enabledBorder: MyBorder.outlineInputBorder(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Upload Product Button
                  SizedBox(height: 1.5.h,),
                //  Gap(1.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: .3.w,),

                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 4.6.h,
                          width: 44.w,
                          decoration: BoxDecoration(
                              color: Colors.red[700],
                              borderRadius: BorderRadius.circular(4)),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 1.2.w,),
                            //  Gap(1.2.w),
                              const Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 3.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan[600],
                            padding:
                                const EdgeInsets.symmetric(horizontal: 43.0)),
                        onPressed: () async {
                          _productModel.name =
                              productNameEditingController.text.toString();
                          _productModel.brand =
                              productBrandEditingController.text.toString();

                          _productModel.description =
                              productDescriptionEditingController.text
                                  .toString();
                          _productModel.isPopular = _isPopular;
                          _productModel.imageUrls =
                              widget.singleProductDtaforUpdate?.imageUrls;

                          /// quantity exception handling
                          if (productQuantityEditingController.text.isEmpty) {
                            MySnackBar().showSnackBar(
                                'Please Enter a Number on Quantity field',
                                context,
                                duration: const Duration(seconds: 2));
                          } else if (_productModel.name.isEmpty) {
                            MySnackBar().showSnackBar(
                                'Please Enter a Product name..', context,
                                duration: const Duration(seconds: 2));
                          } else if (_productModel.brand.isEmpty) {
                            MySnackBar().showSnackBar(
                                'Please Enter a brand for your product',
                                context,
                                duration: const Duration(seconds: 2));
                          } else if (productPriceEditingController.text
                              .toString()
                              .isEmpty) {
                            MySnackBar().showSnackBar(
                                'Please Enter a price for your product',
                                context,
                                duration: const Duration(seconds: 2));
                          } else if (productQuantityEditingController
                              .text.isEmpty) {
                            MySnackBar().showSnackBar(
                                'Please Enter amount of product you have',
                                context,
                                duration: const Duration(seconds: 2));
                          } else if (_productModel.category.isEmpty) {
                            MySnackBar().showSnackBar(
                                'Please select a category for your product',
                                context,
                                duration: const Duration(seconds: 2));
                          } else if (productDescriptionEditingController
                              .text.isEmpty) {
                            MySnackBar().showSnackBar(
                                'Please write a long description of your product',
                                context,
                                duration: const Duration(seconds: 2));
                          } else {
                            /// quantity exception handling
                            try {
                              _productModel.quantity = int.tryParse(
                                      productQuantityEditingController.text
                                          .toString()) ??
                                  0;
                            } catch (e) {
                              MySnackBar().showSnackBar(
                                  'Please Enter a Number on Quantity field',
                                  context,
                                  duration: const Duration(seconds: 2));
                            }

                            /// price exception handling
                            try {
                              _productModel.price = double.tryParse(
                                      productPriceEditingController.text
                                          .toString()) ??
                                  0;
                            } catch (e) {
                              MySnackBar().showSnackBar(
                                  'Please Enter amount of Money on price field',
                                  context,
                                  duration: const Duration(seconds: 2));
                            }
                            setState(() {
                              loadingOnUpload = true;
                            });
                            if (imageList.length <= 1) {
                            } else {
                              for (int i = 1; i < imageList.length; i++) {
                                imageChosenForASingleProduct.add(imageList[i]);
                                setState(() {});
                              }

                              var listOfImageUrlLinks =
                                  await uploadingPictureProvider.uploadPictures(
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
                            });
                          }
                        },
                        label: const Text(
                          'Save',
                          style: TextStyle(fontSize: 20.0, letterSpacing: 3.0),
                        ),
                        icon: const Icon(Icons.save_as, size: 24),
                      ),

                      SizedBox(width: .3.w),
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
