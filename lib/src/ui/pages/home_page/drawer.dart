import 'package:chat_verse/src/core/providers/i_storage_provider.dart';
import 'package:chat_verse/src/ui/mixins/alert_mixin.dart';
import 'package:chat_verse/src/ui/pages/blocs/theme_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/blocs/chat_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/events/chat_event.dart';
import 'package:chat_verse/src/ui/pages/events/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> with AlertDialogMixin {
  bool isDark = false;

  String getTitleByTheme() {
    return isDark ? "Tema claro" : "Tema escuro";
  }

  changeTheme() {
    context.read<ThemeBloc>().add(
          ChangeTheme(
              themeName: isDark ? Brightness.light.name : Brightness.dark.name),
        );

    Navigator.of(context).pop();
  }

  Icon getIconTheme() {
    return isDark ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode);
  }

  deleteMessages() async {
    showAlertDialog(
      context: context,
      title: "Deseja excluir todas as conversas?",
      message:
          "Ao prosseguir, todas as conversas serão excluídas e não será possível reverter essa ação!",
      onAccepted: () {
        context.read<IStorageProvider>().deleteAllData();
        setState(
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Mensagens apagadas com sucesso!"),
              ),
            );
          },
        );
        Navigator.of(context).pop();
        context.read<ChatBloc>().add(GetChatsEvent());
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isDark = Theme.of(context).brightness.name == "dark";
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          ListTile(
            title: Text(getTitleByTheme()),
            leading: getIconTheme(),
            onTap: () => changeTheme(),
          ),
          const Spacer(),
          ListTile(
            title: const Text("Apagar mensagens"),
            leading: const Icon(Icons.delete),
            onTap: deleteMessages,
          ),
          ListTile(
            title: const Text("Sair"),
            leading: const Icon(Icons.logout),
            onTap: () => SystemNavigator.pop(),
          )
        ],
      ),
    );
  }
}
