import 'package:pomodorro/data/service/pom_db_service.dart';
import 'package:pomodorro/presentation/edit/edit_bloc.dart';
import 'package:pomodorro/presentation/home/home_bloc.dart';
import 'package:pomodorro/repository/pom_repository.dart';

class PomDependencyInjector {

  static final PomDependencyInjector instance = PomDependencyInjector();

  static final PomDependencyInjector _instance = PomDependencyInjector._internal();

  factory PomDependencyInjector() {
    return _instance;
  }

  PomDependencyInjector._internal() {
    initializeDependencies();
  }

  // Add your dependencies here
  HomeBloc get homeBloc => HomeBloc();
  
  EditBloc get editBloc => EditBloc();

  late final PomRepository pomRepository;

  late final PomDbService pomDbService;

  void initializeDependencies() {
    pomDbService = PomDbService();

    pomRepository = PomRepository(pomDbService);
  }
}
