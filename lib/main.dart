import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mecene/cubit/mecene_cubit.dart';
import 'package:mecene/repositories/mecene_repository.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

const String clientId = '';
const String backendHost = '';

void main() {
  runApp(const MeceneApp());
}

class MeceneApp extends StatelessWidget {
  const MeceneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => MeceneRepository(host: backendHost, clientId: clientId),
      child: MaterialApp(
        title: 'Mecene',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => MeceneCubit(context.read<MeceneRepository>()),
      child: const MyHomeView(),
    );
  }
}

class MyHomeView extends StatefulWidget {
  const MyHomeView({Key? key}) : super(key: key);

  @override
  State<MyHomeView> createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mecene'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<MeceneCubit, MeceneState>(
              builder: (BuildContext context, MeceneState state) {
                log(name: 'BlocBuilder', '${state.logged}');

                if (state.logged) {
                  return const Text('Logged');
                } else {
                  return SignInButton(
                    Buttons.Google,
                    onPressed: () => context.read<MeceneRepository>().logIn(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
