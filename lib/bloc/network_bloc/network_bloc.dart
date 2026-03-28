import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _streamSubscription;

  NetworkBloc() : super(NetworkInitialState()) {
    // Event handlers
    on<CheckConnection>(_onCheckConnection);

    // App শুরুতেই লিসেনিং শুরু করে দাও (best practice)
    _startListening();
  }

  // Connectivity change শোনা
  void _startListening() {
    _streamSubscription?.cancel(); // আগেরটা থাকলে cancel

    _streamSubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        final isConnected = results.any(
              (element) => element != ConnectivityResult.none,
        );

        if (isConnected) {
          emit(NetworkConnectedState());
        } else {
          emit(NetworkDisconnectedState());
        }
      },
    );
  }

  // ম্যানুয়ালি চেক করতে চাইলে (optional)
  Future<void> _onCheckConnection(
      CheckConnection event,
      Emitter<NetworkState> emit,
      ) async {
    final results = await _connectivity.checkConnectivity();
    final isConnected = results.any(
          (element) => element != ConnectivityResult.none,
    );

    if (isConnected) {
      emit(NetworkConnectedState());
    } else {
      emit(NetworkDisconnectedState());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}