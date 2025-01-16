import 'dart:async';
import 'dart:ui';
import 'package:flutter_bank_app/Presentation/Blocs/language/language_event.dart';
import 'package:flutter_bank_app/Presentation/Blocs/language/language_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('es'))) {
    _loadLanguage();

    on<ChangeLanguageEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', event.locale.languageCode);
      emit(LanguageState(event.locale));
    });
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('selected_language');

    final defaultLocale = savedLanguageCode != null
        ? Locale(savedLanguageCode)
        : const Locale('es');
    add(ChangeLanguageEvent(defaultLocale));
  }
}
