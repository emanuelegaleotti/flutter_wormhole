import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wormhole/core/header.dart';
import 'package:flutter_wormhole/shared/models/keycloak_user.model.dart';
import 'package:flutter_wormhole/store/appauth_state/appauth.bloc.dart';
import 'package:flutter_wormhole/store/appauth_state/appauth.event.dart';
import 'package:flutter_wormhole/store/keycloak_state/keycloak.bloc.dart';
import 'package:flutter_wormhole/store/keycloak_state/keycloak.event.dart';
import 'package:flutter_wormhole/store/keycloak_state/keycloak.state.dart';

import '../../core/bottomNavigation.dart';
import '../../store/auth0_state/auth0.bloc.dart';
import '../../store/auth0_state/auth0.event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<KeycloakBloc>().add(InitKeycloakLogin());
  }

  String getEmail(KeycloakUser? u) {
    if (u != null) {
      return u.email;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        bottomNavigationBar: const BottomNavigation(),
        body: BlocBuilder<KeycloakBloc, KeycloakState>(builder: (ctx, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(getEmail(state.user)),
                TextButton(
                  child: const Text('Login Auth0'),
                  onPressed: () {
                    context.read<Auth0Bloc>().add(InitAuth0Login());
                  },
                ),
                TextButton(
                  child: const Text('Login AppAuth'),
                  onPressed: () {
                    context.read<AppAuthBloc>().add(InitAppAuthLogin());
                  },
                ),
                TextButton(
                    child: const Text('Login Keycloak'),
                    onPressed: () {
                      context.read<KeycloakBloc>().add(KeycloakLogin());
                    }),
                TextButton(
                  child: const Text('Logout Keycloak'),
                  onPressed: () {
                    context.read<KeycloakBloc>().add(KeycloakLogout());
                  },
                )
              ],
            ),
          );
        }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
