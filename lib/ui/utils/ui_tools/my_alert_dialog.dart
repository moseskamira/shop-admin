import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/view_models/auth_provider.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';

class MyAlertDialog {
  void removeItem(context, Function() func) {
    _showDialog(
        'Remove from cart',
        'Are you sure you want to remove this product from your cart?',
        'Remove',
        func,
        context);
  }

  void clearCart(context, Function() func) {
    _showDialog('Clear Cart', 'Are you sure you want to clear your cart?',
        'Clear', func, context);
  }

  Future<void> _showDialog(String title, String content, String buttonTitle,
      Function() func, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                title.toUpperCase(),
              ),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: func,
                  child: Text(buttonTitle.toUpperCase()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'.toUpperCase()),
                )
              ],
            ));
  }

  /// Show sign out dialog
  static Future<void> signOut(context) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Sign Out'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: const Text('Do you want to sign out?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'.toUpperCase())),
                Consumer<AuthProvider>(
                  builder: (_, authProvider, __) => TextButton(
                      onPressed: () async {
                        await authProvider.signOut(context).then((_) {
                       //   Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteName.logInScreen,
                            (Route<dynamic> route) => false,
                          );
                        });
                      },
                      child: Text('Sign Out'.toUpperCase())),
                ),
              ],
            ));
  }

  /// Display [AlertDialog] to pick image with [ImagePicker] and return the
  /// picked image path.

  static Future<dynamic> imagePicker(BuildContext context) async {
    return showDialog(
        context: context, builder: (context) => const ImagePickerDialog());
  }

  static Future<dynamic> imagePickerForAuth(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => const ImagePickerDialogForAuth());
  }

  static Future<void> connectionError(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Oops!'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              content: const Text(
                  'It seems there is something wrong with your internet connection. Please connect to internet and try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  ///Show internet connection error dialog
  static Future<void> error(BuildContext context, String errorText) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Oops!'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              content: Text(errorText),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}

class ImagePickerDialog extends StatefulWidget {
  const ImagePickerDialog({super.key});

  @override
  State<ImagePickerDialog> createState() => _ImagePickerDialogState();
}

class _ImagePickerDialogState extends State<ImagePickerDialog> {
  Future<void> _pickImageCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    Navigator.pop(context, pickedImage!.path);
  }

  Future<void> _pickImageGallery() async {
    List<String> imagePaths = [];
    final pickedImage = await ImagePicker().pickMultiImage();

    if (pickedImage.isNotEmpty) {
      imagePaths = pickedImage.map((image) => image.path).toList();
    }
    Navigator.pop(context, imagePaths);
  }

  void _removeImage() async {
    Navigator.pop(context, '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose Option'.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            ListTile(
              onTap: _pickImageCamera,
              leading: Icon(Icons.camera,
                  color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Camera'),
            ),
            ListTile(
              onTap: _pickImageGallery,
              leading: Icon(Icons.photo,
                  color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePickerDialogForAuth extends StatefulWidget {
  const ImagePickerDialogForAuth({super.key});

  @override
  State<ImagePickerDialogForAuth> createState() =>
      _ImagePickerDialogForAuthState();
}

class _ImagePickerDialogForAuthState extends State<ImagePickerDialogForAuth> {
  Future<void> _pickImageCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    Navigator.pop(context, pickedImage!.path);
  }

  Future<void> _pickImageGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    Navigator.pop(context, pickedImage!.path);
  }

  void _removeImage() async {
    Navigator.pop(context, '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose Option'.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            ListTile(
              onTap: _pickImageCamera,
              leading: Icon(Icons.camera,
                  color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Camera'),
            ),
            ListTile(
              onTap: _pickImageGallery,
              leading: Icon(Icons.photo,
                  color: Theme.of(context).colorScheme.tertiary),
              title: const Text('Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
