import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mecene/repositories/mecene_repository.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class MeceneState extends Equatable {
  late AuthenticationStatus status;

  MeceneState(bool logged) {
    status = logged ? AuthenticationStatus.authenticated : AuthenticationStatus.unauthenticated;
  }
}

class Equatable {}

class MeceneCubit extends Cubit<MeceneState> {
  final MeceneRepository _meceneRepository;

  MeceneCubit(this._meceneRepository) : super(MeceneState(_meceneRepository.logged));
}
