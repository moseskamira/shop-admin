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
import 'package:shop_owner_app/ui/widgets/update_reusable_textField.dart';
import 'package:uuid/uuid.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _categories = CategoryModel().getCategories();

  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _brandFocusNode;
  late final FocusNode _priceFocusNode;
  late final FocusNode _quantityFocusNode;
  late final FocusNode _categoryFocusNode;
  late final FocusNode _descriptionFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _brandController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController.text = _categories[0].title;
    _nameFocusNode = FocusNode();
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
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
  }

  void _submitForm() async {
    ProductModel _productModel = ProductModel();
    FocusScope.of(context).unfocus();
    final uploadingPictureProvider =
        Provider.of<PicturesProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    final imageList =
        Provider.of<ImageListProductUpload>(context, listen: false);

    if (imageList.images.isEmpty) {
      MySnackBar().showSnackBar('Please select at least one image', context,
          duration: const Duration(seconds: 2));
    } else if (isValid) {
      setState(() => _isLoading = true);
      List<String> images = [];

      await uploadingPictureProvider
          .uploadPictures(
              lengthOfImages: imageList.images.length,
              picturesList: imageList.images,
              productsName: _nameController.text.toString())
          .then((img) {
        for (int i = 0; i < img.length; i++) {
          images.add(img[i]);
        }
      });
      _productModel.imageUrls = images;
      _productModel.id = const Uuid().v4();
      _productModel.name = _nameController.text.toString();
      _productModel.brand = _brandController.text.toString();
      _productModel.price =
          double.tryParse(_priceController.text.toString()) ?? 0;
      _productModel.quantity =
          int.tryParse(_quantityController.text.toString()) ?? 0;
      _productModel.category = _categoryController.text.toString();
      _productModel.description = _descriptionController.text.toString();

      _productModel.isPopular = _isPopular;

      _formKey.currentState!.save();

      setState(() {});
      final productProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      await productProvider.addProduct(_productModel).then((_) {
        MySnackBar().showSnackBar('Success', context);
        setState(() {});
        _productModel = ProductModel();
        _formKey.currentState?.reset();

        imageList.clear();
        _nameController.clear();
        _brandController.clear();
        _priceController.clear();
        _quantityController.clear();
        _categoryController.text = _categories[0].title;
        _descriptionController.clear();
        _isPopular = false;
      }).catchError((error) {
        MyAlertDialog.error(context, error.message);
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }

  bool _isPopular = false;
  bool _isFormChanged(BuildContext context) {
    final imageList =
        Provider.of<ImageListProductUpload>(context, listen: false).images;

    // If there are images or any of the fields have been filled, the form has changed
    return imageList.isNotEmpty ||
        _nameController.text.isNotEmpty ||
        _brandController.text.isNotEmpty ||
        _priceController.text.isNotEmpty ||
        _quantityController.text.isNotEmpty ||
        _isPopular ||
        _descriptionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
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
      child: GestureDetector(
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
                                    key: ValueKey(imageList.images[imageIndex]),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Container(
                                      decoration: imageIndex == 0
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
                                              imagePath:
                                                  imageList.images[imageIndex],
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

                        CustomTextField(
                          controller: _nameController,
                          maxLines: 4,
                          // textCapitalization: TextCapitalization.words,
                          validator: (value) =>
                              value!.isEmpty ? 'Required' : null,
                          hintText: 'Add product name...',
                          nextFocusNode: _brandFocusNode,
                          focusNode: _nameFocusNode,
                        ),

                        // Brand Section
                        _sectionTitle('Brand'),
                        CustomTextField(
                          controller: _brandController,
                          focusNode: _brandFocusNode,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) =>
                              value!.isEmpty ? 'Required' : null,
                          hintText: 'Add product brand...',
                          nextFocusNode: _priceFocusNode,
                        ),

                        // Price Section
                        _sectionTitle('Price'),
                        CustomTextField(
                          controller: _priceController,
                          focusNode: _priceFocusNode,
                          //  textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a price";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please enter a valid price";
                            }
                            return null;
                          },
                          hintText: 'Add product price...',
                          nextFocusNode: _quantityFocusNode,
                          keyboardType: TextInputType.number,
                        ),

                        // Quantity Section
                        _sectionTitle('Quantity'),

                        CustomTextField(
                          controller: _quantityController,
                          focusNode: _quantityFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a quantity";
                            }
                            if (int.tryParse(value) == null) {
                              return "Please enter a valid integer";
                            }
                            return null;
                          },
                          hintText: 'Add product quantity...',
                          nextFocusNode: _categoryFocusNode,
                          keyboardType: TextInputType.number,
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
                          //will check this what it is
                          value: _categoryController.text,
                          onChanged: (String? value) {
                            setState(() {
                              _categoryController.text = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                            enabledBorder:
                                MyBorder.underlineInputBorder(context),
                          ),
                        ),

                        // Description Section
                        _sectionTitle('Description'),
                        const SizedBox(height: 10),

                        CustomTextField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) =>
                              value!.isEmpty ? 'Required' : null,
                          hintText: 'Add product description...',
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
