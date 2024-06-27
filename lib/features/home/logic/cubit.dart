import 'package:e_commerce/core/logic/api_service.dart';
import 'package:e_commerce/features/home/model/products_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit(this._apiService) : super(HomeStates());

  final ApiService _apiService;

  List<ProductsModel>? productsList;

  List<dynamic> categories = [];

  Future<void> getProducts() async {
    emit(LoadingProductsState());

    final response = await _apiService.getFromServer(
      url: "products",
    );

    if (response.success) {
      emit(
        SuccessProductsState(),
      );
      productsList = ProductsData.fromJson(response.response!.data).products;
    } else {
      emit(
        FailedProductsState(
          "Something Wrong, Please Try Again...",
        ),
      );
    }
  }

  Future<void> getCategories() async {
    final response = await _apiService.getFromServer(
      url: "products/categories",
    );

    if (response.success) {
      emit(
        SuccessCategoriesState(),
      );
      categories.addAll(response.response!.data);
    } else {
      emit(
        FailedCategoriesState(
          "Something Wrong, Please Try Again...",
        ),
      );
    }
  }
}
