import 'package:fluent_ui/fluent_ui.dart';

showCreateCredentialDialog(BuildContext context) async {
  String prevValue = "";
  TextEditingController passwordController =
      TextEditingController(text: prevValue);
  showDialog(
      context: context,
      builder: (context) => ContentDialog(
            title: const Text("Identifiants"),
            content: StatefulBuilder(
                builder: (BuildContext context, setDialogState) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                            "Create a identifiant to secure your passwords"),
                        const SizedBox(
                          height: 8,
                        ),
                        TextBox(
                          placeholder: "Password",
                          controller: passwordController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          onChanged: (value) {
                            if (!RegExp(r'(\d+)').hasMatch(value)) {
                              setDialogState(() {
                                passwordController.text = prevValue;
                                passwordController.selection = TextSelection(
                                    baseOffset: prevValue.length,
                                    extentOffset: prevValue.length);
                              });
                            } else {
                              prevValue = value;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Checkbox(checked: true, onChanged: (value) => {}),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text("Only digit as password"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(checked: true, onChanged: (value) => {}),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text("Six characters maximum"),
                          ],
                        )
                      ],
                    )),
            actions: [
              Button(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context)),
              FilledButton(child: const Text("Create"), onPressed: () {})
            ],
          ));
}

showCreatePasswordDialog(BuildContext context, Function callback) async {
  TextEditingController passwordController = TextEditingController();
  bool passwordObscured = true;
  bool useUsername = false;
  final result = await showDialog(
      context: context,
      builder: (context) => ContentDialog(
            title: const Text("New password"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setDialogState) =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Save a new password to keep it safe."),
                        const SizedBox(
                          height: 8,
                        ),
                        const TextBox(
                          placeholder: "Title",
                          expands: false,
                        ),
                        if (useUsername) ...const [
                          SizedBox(
                            height: 8,
                          ),
                          TextBox(
                            placeholder: "Username",
                          ),
                        ],
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: TextBox(
                              placeholder: "Password",
                              controller: passwordController,
                              obscureText: passwordObscured,
                              expands: false,
                              suffix: IconButton(
                                  icon: passwordObscured
                                      ? const Icon(FluentIcons.view)
                                      : const Icon(FluentIcons.hide3),
                                  onPressed: () {
                                    setDialogState(() =>
                                        passwordObscured = !passwordObscured);
                                  }),
                            )),
                            const SizedBox(
                              width: 8,
                            ),
                            IconButton(
                                icon: const Icon(FluentIcons.paste),
                                onPressed: () => {})
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Button(
                            child: const Text("Generate"),
                            onPressed: () {
                              String generated = callback();
                              setDialogState(
                                  () => passwordController.text = generated);
                            }),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                                checked: useUsername,
                                onChanged: (value) {
                                  setDialogState(
                                      () => useUsername = value ?? false);
                                }),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text("Use a username for this account")
                          ],
                        )
                      ],
                    )),
            actions: [
              Button(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context)),
              FilledButton(child: const Text("Create"), onPressed: () {})
            ],
          ));
}

Future<T?> showLoginDialog<T extends Object?>(
    BuildContext context, Function(String) callback) async {
  TextEditingController passwordController = TextEditingController();
  bool error = false;
  return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => ContentDialog(
                title: const Text("Log in"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        "Use a manager password to see all your others passwords."),
                    const SizedBox(
                      height: 8,
                    ),
                    TextBox(
                      placeholder: "Password",
                      obscureText: true,
                      expands: false,
                      controller: passwordController,
                      autofocus: true,
                      onChanged: (value) => setDialogState(() => error = false),
                      suffix: IconButton(
                          icon: const Icon(FluentIcons.view),
                          onPressed: () => {}),
                    ),
                    if (error) ...const [
                      SizedBox(
                        height: 8,
                      ),
                      InfoBar(
                        title: Text("Authentification failed!"),
                        content: Text(
                            "You have entered a bad password. Please try again"),
                        severity: InfoBarSeverity.warning,
                      )
                    ]
                  ],
                ),
                actions: [
                  Button(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context)),
                  FilledButton(
                      child: const Text("Log in"),
                      onPressed: () {
                        bool value = callback(passwordController.text);
                        if (value) {
                          Navigator.pop(context, value);
                        } else {
                          setDialogState(() => error = true);
                        }
                      })
                ],
              )));
}
