import 'package:chat_verse/src/ui/pages/blocs/theme_bloc.dart';
import 'package:chat_verse/src/ui/pages/events/theme_event.dart';
import 'package:chat_verse/src/ui/pages/home_page/home_page.dart';
import 'package:chat_verse/src/ui/pages/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThemeBloc>().add(GetCurrentThemeEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (_, themeState) {
        String? isDark;

        if (themeState is LoadedThemeState) {
          isDark = themeState.themeName;
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDark == "dark" ? ThemeData.dark() : ThemeData.light(),
          home: const HomePage(),
        );
      },
    );
  }
}
