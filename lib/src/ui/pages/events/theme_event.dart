abstract class ThemeEvent {}

class GetCurrentThemeEvent extends ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final String themeName;

  ChangeTheme({required this.themeName});
}
