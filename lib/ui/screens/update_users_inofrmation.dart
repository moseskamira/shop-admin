import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/enums/app_enums.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/core/view_models/profile_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_snackbar.dart';
import 'package:shop_owner_app/ui/widgets/reusable_text_field.dart';

import '../widgets/update_image_preview.dart';

class UpdateUsersInformation extends StatefulWidget {
  final UserModel userModel;

  const UpdateUsersInformation({super.key, required this.userModel});

  @override
  State<UpdateUsersInformation> createState() => _UpdateUsersInformationState();
}

class _UpdateUsersInformationState extends State<UpdateUsersInformation> {
  late final FocusNode _nameNode;
  late final FocusNode _phoneNumberNode;
  late final FocusNode _addressNode;
  final _formKey = GlobalKey<FormState>();
  String initialImagePath = '';
  late final TextEditingController fullNameEditingController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController addressEditingController;

  @override
  void initState() {
    super.initState();

    _nameNode = FocusNode();
    _phoneNumberNode = FocusNode();
    _addressNode = FocusNode();
    fullNameEditingController = TextEditingController();
    phoneNumberController = TextEditingController();
    addressEditingController = TextEditingController();

    fullNameEditingController.text = widget.userModel.fullName;
    phoneNumberController.text = widget.userModel.phoneNumber;
    addressEditingController.text = widget.userModel.address;
    initialImagePath = widget.userModel.imageUrl;
  }

  @override
  void dispose() {
    super.dispose();
    _nameNode.dispose();
    _phoneNumberNode.dispose();
    _addressNode.dispose();
    fullNameEditingController.dispose();
    phoneNumberController.dispose();
    addressEditingController.dispose();
  }

  void _submitForm(ProfileProvider provider, BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    final pictureProvider =
        Provider.of<PicturesProvider>(context, listen: false);
    if (initialImagePath != widget.userModel.imageUrl) {
      if (initialImagePath.contains('firebasestorage')) {
        await pictureProvider.deleteSinglePicture(url: initialImagePath);
        await pictureProvider
            .uploadSinglePicture(
          fileLocationinDevice: widget.userModel.imageUrl,
        )
            .then((fileUrl) {
          setState(() {
            widget.userModel.imageUrl = fileUrl;
          });
        });
      } else {
        await pictureProvider
            .uploadSinglePicture(
          fileLocationinDevice: widget.userModel.imageUrl,
        )
            .then((url) {
          widget.userModel.imageUrl = url;
          setState(() {});
        });
      }
    } else {
      widget.userModel.imageUrl = initialImagePath;
    }
    await provider.updateProfile(widget.userModel);
    if (provider.userState == ProfileStates.updateError && ctx.mounted) {
      MySnackBar().showSnackBar(
        content: provider.updateError,
        context: ctx,
        backgroundColor: Colors.black12,
        duration: const Duration(seconds: 4),
      );
    }

    if (provider.userState == ProfileStates.updateSuccess && ctx.mounted) {
      MySnackBar().showSnackBar(
        content: 'Profile updated successfully',
        context: ctx,
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.06, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Center(
                    child: Stack(
                      children: [
                        UpdateImagePreViewer(
                          imagePath: widget.userModel.imageUrl,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: SizedBox(
                            height: 26,
                            width: 26,
                            child: RawMaterialButton(
                              elevation: 5,
                              fillColor: Theme.of(context).primaryColor,
                              shape: const CircleBorder(),
                              onPressed: () async {
                                MyAlertDialog.imagePickerForAuth(context).then(
                                  (pickedImagePath) {
                                    if (pickedImagePath != null &&
                                        pickedImagePath.toString().isNotEmpty) {
                                      setState(() => widget.userModel.imageUrl =
                                          pickedImagePath);
                                    }
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name TextFormField
                        ReusableTextField(
                          valueKey: 'Full Name',
                          hintText: 'Enter your full name',
                          controller: fullNameEditingController,
                          focusNode: _nameNode,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your full name'
                              : null,
                          keyboardType: TextInputType.name,
                          labelText: 'Full Name',
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneNumberNode),
                          onSaved: (value) =>
                              widget.userModel.fullName = value!,
                        ),

                        // Phone Number TextFormField
                        ReusableTextField(
                          valueKey: 'Phone Number',
                          hintText: 'Enter your Phone Number',
                          controller: phoneNumberController,
                          focusNode: _phoneNumberNode,
                          textInputAction: TextInputAction.next,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid phone number'
                              : null,
                          keyboardType: TextInputType.phone,
                          labelText: 'Phone Number',
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_addressNode),
                          onSaved: (value) =>
                              widget.userModel.phoneNumber = value!,
                        ),

                        // Address
                        ReusableTextField(
                          valueKey: 'Address',
                          hintText: 'Enter your Address',
                          controller: addressEditingController,
                          focusNode: _addressNode,
                          textInputAction: TextInputAction.done,
                          labelText: 'Address',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a valid Address'
                              : null,
                          onSaved: (value) => widget.userModel.address = value!,
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: Material(
                                color: Theme.of(context).primaryColor,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Center(
                                    child: Text(
                                      'Cancel !'.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Consumer<ProfileProvider>(
                                builder: (context, userDataProvider, child) {
                              return SizedBox(
                                height: 50,
                                width: 100,
                                child: Material(
                                  color: Theme.of(context).primaryColor,
                                  child: InkWell(
                                    onTap: userDataProvider.userState ==
                                            ProfileStates.updateLoading
                                        ? () {}
                                        : () {
                                            _submitForm(
                                                userDataProvider, context);
                                            FocusScope.of(context).unfocus();
                                          },
                                    child: Center(
                                        child: userDataProvider.userState ==
                                                ProfileStates.updateLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.orange,
                                              )
                                            : Text(
                                                'Update !'.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              )),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
