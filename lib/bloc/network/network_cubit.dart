import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionStatus { connected, disconnected }

class NetworkConnectionState {
  final ConnectionStatus status;

  NetworkConnectionState(this.status);
}

class NetworkCubit extends Cubit<NetworkConnectionState> {
  final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> _connectivityStream;

  NetworkCubit(this._connectivity) : super(NetworkConnectionState(ConnectionStatus.disconnected)) {
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivityStream.listen((connectivityResult) {
      if (connectivityResult.first == ConnectivityResult.none) {
        emit(NetworkConnectionState(ConnectionStatus.disconnected));
      } else {
        emit(NetworkConnectionState(ConnectionStatus.connected));
      }
    });
  }

  Future<void> checkInitialConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(NetworkConnectionState(ConnectionStatus.disconnected));
    } else {
      emit(NetworkConnectionState(ConnectionStatus.connected));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
