import 'package:chat_verse/src/core/providers/google_gemini_provider.dart';
import 'package:chat_verse/src/core/providers/http_provider.dart';
import 'package:chat_verse/src/core/providers/i_ai_provider.dart';
import 'package:chat_verse/src/core/providers/i_http_provider.dart';
import 'package:chat_verse/src/core/providers/i_storage_provider.dart';
import 'package:chat_verse/src/core/providers/shared_preferences_provider.dart';
import 'package:chat_verse/src/data/repositories/chat_repository.dart';
import 'package:chat_verse/src/data/services/chat_service.dart';
import 'package:chat_verse/src/data/services/storage_service.dart';
import 'package:chat_verse/src/ui/pages/blocs/theme_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/blocs/chat_bloc.dart';
import 'package:chat_verse/src/ui/pages/chat_page/blocs/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AppConfig extends StatelessWidget {
  final Widget child;
  const AppConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      // providers
      Provider<IHttpProvider>(
        create: (context) => HttpProvider(),
      ),
      Provider<IStorageProvider>(
        create: (context) => SharedPreferencesProvider(),
      ),
      Provider<IAiProvider>(
        create: (context) => GoogleGeminiProvider(),
      ),

      // repositories
      Provider(
        create: (context) => ChatRepository(
          context.read<IStorageProvider>(),
        ),
      ),

      // services
      Provider(
        create: (context) => ChatService(
          context.read<ChatRepository>(),
        ),
      ),
      Provider(
        create: (context) => StorageService(context.read<IStorageProvider>()),
      ),

      // blocs
      BlocProvider(
        create: (context) => ChatBloc(
          context.read<ChatService>(),
        ),
      ),
      BlocProvider(
        create: (context) => MessageBloc(
            context.read<ChatService>(), context.read<IAiProvider>()),
      ),
      BlocProvider(
        create: (context) => ThemeBloc(context.read<StorageService>()),
      )
    ], child: child);
  }
}
