import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>((event, emit) async {
      emit(SplashLoading());
      // Simulate loading some data or initialization
      await Future.delayed(const Duration(seconds: 3));
      emit(SplashLoaded());
    });
  }
}
