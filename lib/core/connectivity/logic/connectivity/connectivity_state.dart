part of 'connectivity_cubit.dart';

@freezed
abstract class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState.initial() = _Initial;
  const factory ConnectivityState.connected() = Connected;
  const factory ConnectivityState.disconnected() = Disconnected;
}
