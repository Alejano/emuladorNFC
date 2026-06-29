import 'package:emuladornfc/core/routing/app_router.dart';
import 'package:emuladornfc/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:emuladornfc/features/splash/presentation/bloc/splash_event.dart';
import 'package:emuladornfc/features/splash/presentation/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            context.go(AppRouter.home);
          }
        },
        child: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(size: 100),
                SizedBox(height: 20),
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Cargando Demo NFC...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
