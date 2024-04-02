import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_verse/src/data/services/storage_service.dart';
import 'package:chat_verse/src/ui/pages/events/theme_event.dart';
import 'package:chat_verse/src/ui/pages/states/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService _storageService;
  ThemeBloc(this._storageService) : super(InitialThemeState("light")) {
    on(_mapEventToState);
  }

  Future _mapEventToState(ThemeEvent event, Emitter<ThemeState> emit) async {
    if (event is GetCurrentThemeEvent) {
      String? currentTheme = await _storageService.getTheme();
      if (currentTheme == null) {
        await _storageService.setTheme("dark");
        currentTheme = "dark";
      }

      emit(LoadedThemeState(themeName: currentTheme));
    }

    if (event is ChangeTheme) {
      await _storageService.setTheme(event.themeName);
      emit(LoadedThemeState(themeName: event.themeName));
    }
  }
}
