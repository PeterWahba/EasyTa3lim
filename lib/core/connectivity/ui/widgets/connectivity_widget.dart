import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/connectivity/connectivity_cubit.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return const SizedBox.shrink();
            },
            connected: () {
              return const SizedBox.shrink();
            },
            disconnected: () {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50.0,
                color: Colors.red,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white),
                      SizedBox(width: 10,),
                      Text(
                       "Error On Internet Connection",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                           ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
