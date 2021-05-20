import 'package:coral_reef/services/step_service.dart';
import 'package:get_it/get_it.dart';


//Created by Daniel Makinde
//This is where all services is setup
GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => StepService());


}
