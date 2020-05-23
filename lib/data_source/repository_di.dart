import 'package:pubg/data_source/firestore_repository.dart';
import 'package:pubg/data_source/user_repository.dart';

class RepositoryInjector {
  static final RepositoryInjector _repositoryInjector = RepositoryInjector._internal();

  RepositoryInjector._internal();

  factory RepositoryInjector() {
    return _repositoryInjector;
  }

  static final UserRepository userRepository = UserRepository();
  static final FireStoreRepository fireStoreRepository = FireStoreRepository();
}