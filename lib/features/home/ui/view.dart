import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/helper/extension.dart';
import 'package:e_commerce/features/home/logic/cubit.dart';
import 'package:e_commerce/features/home/logic/states.dart';
import 'package:e_commerce/features/home/model/products_data.dart';
import 'package:e_commerce/features/product_details/ui/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiwi/kiwi.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> iconsPath = [
    "electronics.svg",
    "jewelery.svg",
    "men's_clothing.svg",
    "women's_clothing.svg",
  ];
  final cubit = KiwiContainer().resolve<HomeCubit>()..getProducts();
  final categories = KiwiContainer().resolve<HomeCubit>()..getCategories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 8.w,
            vertical: 13.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalSpace(10),
              BlocBuilder(
                bloc: categories,
                builder: (context, state) {
                  if (state is SuccessCategoriesState) {
                    return SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategoriesItem(
                          index,
                        ),
                        itemCount: categories.categories.length,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              verticalSpace(10),
              Text(
                "Products",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalSpace(10),
              BlocBuilder(
                bloc: cubit,
                builder: (context, state) {
                  if (state is LoadingProductsState) {
                    return buildHomeLoading();
                  } else if (state is SuccessProductsState) {
                    final model = cubit.productsList!;
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 0.56,
                      ),
                      itemBuilder: (context, index) => buildGridItem(
                        model,
                        index,
                      ),
                      itemCount: cubit.productsList!.length,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoriesItem(int index) {
    return Container(
      width: 100.w,
      height: 100.h,
      margin: EdgeInsetsDirectional.only(
        start: index == 0 ? 0 : 8.w,
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/${iconsPath[index]}",
            width: 40.w,
            height: 40.h,
          ),
          verticalSpace(10),
          Text(
            categories.categories[index],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(List<ProductsModel> model, int index) {
    return GestureDetector(
      onTap: () {
        context.push(
          ProductDetails(
            model: model[index],
            id: model[index].id,
          ),
        );
      },
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 5.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurStyle: BlurStyle.outer,
              blurRadius: 3.r,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildGridItemImage(model, index),
            verticalSpace(5),
            buildDivider(),
            verticalSpace(5),
            Text(
              model[index].title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            verticalSpace(10),
            Text(
              "Price : ${model[index].price}",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItemImage(List<ProductsModel> model, int index) {
    return CachedNetworkImage(
      imageUrl: model[index].image,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return buildShimmer();
      },
      imageBuilder: (context, imageProvider) => Container(
        width: 200.w,
        height: 200.h,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.r),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Divider(
      thickness: 2.h,
    );
  }

  Widget buildHomeLoading() {
    return GridView.builder(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.w,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 0.56,
      ),
      itemBuilder: (context, index) => buildShimmer(),
      itemCount: 10,
    );
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Container(
        width: 200.w,
        height: 200.h,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
        ),
      ),
    );
  }
}
