class HomeStates {}

class LoadingProductsState extends HomeStates {}

class SuccessProductsState extends HomeStates {}

class FailedProductsState extends HomeStates {
  final String msg;

  FailedProductsState(this.msg);
}

class SuccessCategoriesState extends HomeStates {}

class FailedCategoriesState extends HomeStates {
  final String msg;

  FailedCategoriesState(this.msg);
}
