import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/enums/app_enums.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/picture_provider.dart';
import 'package:shop_owner_app/core/view_models/profile_provider.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_alert_dialog.dart';
import 'package:shop_owner_app/ui/utils/ui_tools/my_snackbar.dart';
import 'package:shop_owner_app/ui/widgets/reusable_text_field.dart';

import '../widgets/custom_image_preview.dart';

class UpdateUsersInformation extends StatefulWidget {
  final UserModel userModel;

  const UpdateUsersInformation({
    super.key,
    required this.userModel,
  });

  @override
  State<UpdateUsersInformation> createState() => _UpdateUsersInformationState();
}

class _UpdateUsersInformationState extends State<UpdateUsersInformation> {
  final _formKey = GlobalKey<FormState>();
  late final FocusNode _nameNode = FocusNode();
  late final FocusNode _phoneNumberNode = FocusNode();
  late final FocusNode _addressNode = FocusNode();
  late final TextEditingController fullNameController =
      TextEditingController(text: widget.userModel.fullName);
  late final TextEditingController phoneNumberController =
      TextEditingController(text: widget.userModel.phoneNumber);
  late final TextEditingController addressController =
      TextEditingController(text: widget.userModel.address);
  String initialImagePath = '';

  @override
  void initState() {
    super.initState();
    initialImagePath = widget.userModel.imageUrl;
  }

  @override
  void dispose() {
    _nameNode.dispose();
    _phoneNumberNode.dispose();
    _addressNode.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _unFocus() => FocusScope.of(context).unfocus();

  Future<void> _submitForm(ProfileProvider provider, BuildContext ctx,
      AppLocalizations appLocal) async {
    if (!_formKey.currentState!.validate()) return;
    _unFocus();
    _formKey.currentState!.save();
    final pictureProvider =
        Provider.of<PicturesProvider>(context, listen: false);
    if (initialImagePath != widget.userModel.imageUrl) {
      if (initialImagePath.contains('firebasestorage')) {
        await pictureProvider.deleteSinglePicture(url: initialImagePath);
      }
      widget.userModel.imageUrl = await pictureProvider.uploadSinglePicture(
          fileLocationinDevice: widget.userModel.imageUrl);
    }
    await provider.updateProfile(widget.userModel);
    if (!ctx.mounted) return;

    final message = provider.userState == ProfileStates.updateSuccess
        ? appLocal.profileUpdatedSuccessfully
        : provider.updateError;

    MySnackBar().showSnackBar(
      content: message,
      context: ctx,
      backgroundColor: provider.userState == ProfileStates.updateSuccess
          ? Colors.blue
          : Colors.black12,
      duration: const Duration(seconds: 4),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        children: [
          CustomImagePreView(imagePath: widget.userModel.imageUrl),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.add_a_photo, color: Colors.blue, size: 24),
              onPressed: () async {
                final pickedImagePath =
                    await MyAlertDialog.imagePickerForAuth(context);
                if (pickedImagePath != null && pickedImagePath.isNotEmpty) {
                  setState(() => widget.userModel.imageUrl = pickedImagePath);
                }
              },
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFields() {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        ReusableTextField(
          valueKey: appLocalizations.fullName,
          hintText: appLocalizations.enterYourFullName,
          controller: fullNameController,
          focusNode: _nameNode,
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              value!.isEmpty ? appLocalizations.pleaseEnterYourFullName : null,
          keyboardType: TextInputType.name,
          labelText: appLocalizations.fullName,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(_phoneNumberNode),
          onSaved: (value) => widget.userModel.fullName = value!,
        ),
        ReusableTextField(
          valueKey: appLocalizations.phoneNumber,
          hintText: appLocalizations.enterYourPhoneNumber,
          controller: phoneNumberController,
          focusNode: _phoneNumberNode,
          keyboardType: TextInputType.phone,
          labelText: appLocalizations.phoneNumber,
          validator: (value) => value!.isEmpty
              ? appLocalizations.pleaseEnterValidPhoneNumber
              : null,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(_addressNode),
          onSaved: (value) => widget.userModel.phoneNumber = value!,
        ),
        ReusableTextField(
          valueKey: appLocalizations.emailAddress,
          hintText: appLocalizations.enterYourEmailAddress,
          controller: addressController,
          focusNode: _addressNode,
          labelText: appLocalizations.emailAddress,
          validator: (value) => value!.isEmpty
              ? appLocalizations.pleaseEnterValidEmailAddress
              : null,
          onSaved: (value) => widget.userModel.address = value!,
        ),
      ],
    );
  }

  Widget _buildButtons() {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Row(
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.cancel),
        ),
        const Spacer(),
        Consumer<ProfileProvider>(
          builder: (context, provider, child) =>
              provider.userState == ProfileStates.updateLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _submitForm(
                        provider,
                        context,
                        appLocalizations,
                      ),
                      child: Text(appLocalizations.update),
                    ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: _unFocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appLocalizations.updateProfileInfo,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).size.height * 0.06,
            20,
            16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 20),
              Form(key: _formKey, child: _buildTextFields()),
              const SizedBox(height: 16),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
