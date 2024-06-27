import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/helper/extension.dart';
import 'package:e_commerce/features/home/model/products_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.model, required this.id});

  final ProductsModel model;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          model.title,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: model.image,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.scaleDown,
              ),
              verticalSpace(20),
              Text(
                "Title : ${model.title}",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              verticalSpace(10),
              Text(
                "Price : ${model.price}",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              verticalSpace(10),
              Text(
                "Description : ${model.description}",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              verticalSpace(10),
              Text(
                "Category : ${model.category}",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              verticalSpace(10),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  horizontalSpace(5),
                  Text(
                    model.rating.rate.toString(),
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  horizontalSpace(25),
                  Text(
                    "No of Rates : ${model.rating.count}",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
