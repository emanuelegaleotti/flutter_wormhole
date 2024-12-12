import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wormhole/store/app.state.dart';
import 'package:flutter_wormhole/store/appauth_state/appauth.bloc.dart';
import 'package:flutter_wormhole/store/auth0_state/auth0.bloc.dart';
import 'package:flutter_wormhole/store/keycloak_state/keycloak.bloc.dart';
import 'package:provider/provider.dart';
import 'features/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => Auth0Bloc()),
          BlocProvider(create: (_) => AppAuthBloc()),
          BlocProvider(create: (_) => KeycloakBloc())
        ],
        child: ChangeNotifierProvider(
            create: (ctx) => AppState(),
            child: MaterialApp(
              title: 'Flutter Wormhole',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const HomePage(),
            )));
  }
}
