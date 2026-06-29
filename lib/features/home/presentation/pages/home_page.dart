import 'package:emuladornfc/features/home/presentation/bloc/home_bloc.dart';
import 'package:emuladornfc/features/home/presentation/bloc/home_event.dart';
import 'package:emuladornfc/features/home/presentation/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NFC HCE Receiver'),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.nfc,
                      size: 100,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Servicio HCE Activo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Acerca un terminal que envíe datos NDEF para capturar la URL.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'AID Registrado:\nD2760000850101',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
