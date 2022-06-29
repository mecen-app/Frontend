import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mecene/repositories/mecene_repository.dart';

class MeceneState {
  bool logged;

  MeceneState(this.logged);
}

class MeceneCubit extends Cubit<MeceneState> {
  final MeceneRepository _meceneRepository;

  MeceneCubit(this._meceneRepository) : super(MeceneState(false)) {
    _meceneRepository.getTokenFromStorage().then((token) {
      if (token != null) {
        state.logged = _meceneRepository.logged;
        emit(state);
      }
    });
  }
}
