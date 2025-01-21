import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connectivity_state.dart';
part 'connectivity_cubit.freezed.dart';

enum ConnectionStatus { connected, disconnected }

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> connectivityStreamSubscription;

  ConnectivityCubit(this.connectivity)
      : super(const ConnectivityState.initial()) {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        emitInternetDisconnected();
      } else {
        emitInternetConnected();
      }
    });
  }

  void emitInternetConnected() => emit(const ConnectivityState.connected());

  void emitInternetDisconnected() =>
      emit(const ConnectivityState.disconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
