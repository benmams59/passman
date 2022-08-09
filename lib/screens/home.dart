import 'package:fluent_ui/fluent_ui.dart';
import 'package:passman/models/password.dart';
import 'package:passman/widgets/page.dart';
import 'dart:math' as math;
import 'package:passman/utils/utils.dart' as utils;
import 'package:passman/utils/home_dialogs.dart';

class HomePage extends ScrollablePage {
  bool _logged = false;
  List<Password> _passwords = [];

  String generatePassword() {
    var length = 8,
        charset =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\$%^&()_+=-{};",
        retVal = "";
    for (var i = 0, n = charset.length; i < length; ++i) {
      retVal += charset[math.Random().nextInt(n - 1)];
    }
    return retVal;
  }

  bool _login(String password) {
    _logged = password == "123456";
    return _logged;
  }

  @override
  Widget buildHeader(BuildContext context) {
    return PageHeader(
      title: const Text("Passwords Manager"),
      commandBar: Row(
        children: [
          IconButton(
              icon: const Icon(FluentIcons.add),
              onPressed: !_logged
                  ? null
                  : () => showCreatePasswordDialog(context, generatePassword)),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  void onLoginTapped(BuildContext context) {
    showLoginDialog(context, _login).then((value) {
      if (value == true) {
        setState(() {});
      }
    });
  }

  Widget buildPasswords(BuildContext context) {
    if (!utils.isHashed()) {
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("Create an identifiant to manage your password."),
          const SizedBox(
            width: 8,
          ),
          Button(
              child: const Text("New ID"),
              onPressed: () => showCreateCredentialDialog(context))
        ],
      );
    }

    if (!_logged) {
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("Please log in before."),
          const SizedBox(
            width: 8,
          ),
          Button(
              child: const Text("Login"),
              onPressed: () => onLoginTapped(context))
        ],
      );
    } else {
      if (_passwords.isNotEmpty) {
        return ListView(
          shrinkWrap: true,
          children: [Button(child: const Text("Hello"), onPressed: () => {})],
        );
      } else {
        return Wrap(
          children: const [Text("Your list of passwords is empty.")],
        );
      }
    }
  }

  @override
  List<Widget> buildScrollable(BuildContext context) {
    return [
      Expander(
          header: const Text("Passwords"),
          initiallyExpanded: true,
          content: buildPasswords(context))
    ];
  }
}
