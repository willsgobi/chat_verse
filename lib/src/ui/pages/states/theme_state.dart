abstract class ThemeState {}

class InitialThemeState extends ThemeState {
  final String themeName;

  InitialThemeState(this.themeName);
}

class LoadingThemeState extends ThemeState {}

class LoadedThemeState extends ThemeState {
  final String themeName;

  LoadedThemeState({required this.themeName});
}
