import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/models/crypt.dart';
import 'package:hanshow_project_google_sheets/widgets/my_toast.dart';
import '../models/change_password.dart';
import '../utils/shared_preferences_util.dart';
import '../models/crypt.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  List<bool> passwordInvisible = [true, true, true];
  final _formKey = GlobalKey<FormState>();
  String? oldpass;

  @override
  void initState() {

    Future.delayed(Duration.zero, () async {
      oldpass = await ChangePassword()
          .getPassword(SharedPreferenceUtil.getString('email'));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "Change Password For \n${SharedPreferenceUtil.getString('email')}"),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //position
          mainAxisSize: MainAxisSize.min,
          // wrap content in flutter
          children: [
            TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required";
                  }
                  return Security(text: value).encrypt() != oldpass
                      ? 'Wrong password'
                      : null;
                },
                controller: _oldPasswordController,
                onEditingComplete: () {
				  // Move the focus to the next node explicitly.
                  FocusScope.of(context).nextFocus();
                  FocusScope.of(context).nextFocus();
                },
                obscureText: passwordInvisible[0],
                decoration: showPasswordDeco("Enter your old Password", 0)),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                validator: (value) => passValidator(value),
                controller: _newPasswordController,
                onEditingComplete: () {
				  // Move the focus to the next node explicitly.
                  FocusScope.of(context).nextFocus();
                  FocusScope.of(context).nextFocus();
                },
                obscureText: passwordInvisible[1],
                decoration: showPasswordDeco("Enter your new password", 1)),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                validator: (value) => passValidator(value),
                controller: _confirmPasswordController,
                obscureText: passwordInvisible[2],
                decoration: showPasswordDeco("Confirm your new password", 2),
                onEditingComplete: () {
              // Change password
              if (_formKey.currentState!.validate()) {
                Future.delayed(Duration.zero, () async {
                  bool success = await ChangePassword().change(
                      SharedPreferenceUtil.getString('email'),
                      oldpass,
                      Security(text: _newPasswordController.text).encrypt());
                  if (success) {
                    Navigator.pop(context);
                    MyToast.show('Password Updated!');
                  } else {
                    MyToast.show('Password Update Failed!');
                  }
                });
              }
                },
                ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL')),
        TextButton(
            onPressed: () {
              // Change password
              if (_formKey.currentState!.validate()) {
                Future.delayed(Duration.zero, () async {
                  bool success = await ChangePassword().change(
                      SharedPreferenceUtil.getString('email'),
                      oldpass,
                      Security(text: _newPasswordController.text).encrypt());
                  if (success) {
                    Navigator.pop(context);
                    MyToast.show('Password Updated!');
                  } else {
                    MyToast.show('Password Update Failed!');
                  }
                });
              }
            },
            child: const Text('CONFIRM')),
      ],
    );
  }

  String? passValidator(val) {
    if (val!.isEmpty) {
      return "Required";
    }
    if (val.length < 8) {
      return "Password must be at least 8 characters long";
    }
    if (val.length > 20) {
      return "Password must be less than 20 characters";
    }
    if (!val.contains(RegExp(r'[0-9]'))) {
      return "Password must contain a number";
    }
    if (!val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain a special characters";
    }
    if (_confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty) {
      return _confirmPasswordController.text == _newPasswordController.text
          ? null
          : "Passwords are not same";
    }
    return null;
  }

  showPasswordDeco(text, i) {
    return InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            passwordInvisible[i] ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              passwordInvisible[i] = !passwordInvisible[i];
            });
          },
        ),
        hintText: text,
        border: const OutlineInputBorder(),
        // errorText: _getErrorText(),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0));
  }
}
