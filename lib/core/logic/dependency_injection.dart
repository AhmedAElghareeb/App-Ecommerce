import 'package:e_commerce/core/logic/api_service.dart';
import 'package:e_commerce/features/home/logic/cubit.dart';
import 'package:kiwi/kiwi.dart';

void initDependencyInjection() {
  KiwiContainer c = KiwiContainer();

  //make instance one time of api service
  c.registerSingleton((container) => ApiService());

  //Cubits
  c.registerFactory((container) => HomeCubit(container.resolve<ApiService>()));
}
