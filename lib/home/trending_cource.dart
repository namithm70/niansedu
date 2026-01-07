import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edxera/controller/controller.dart';
import 'package:edxera/cources/cources.dart';
import 'package:edxera/repositories/api/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:edxera/utils/slider_page_data_model.dart';

import '../languagecontrols/LanguageCheck.dart';
import '../utils/screen_size.dart';
import '../utils/shared_pref.dart';

class TrendingCource extends StatefulWidget {
  const TrendingCource({Key? key}) : super(key: key);

  @override
  State<TrendingCource> createState() => _TrendingCourceState();
}

class _TrendingCourceState extends State<TrendingCource> {
  TrendingController homecontroller = Get.put(TrendingController());

  List cource = Utils.getTrending();
  toggle(int index) {
    setState(() {
      if (cource[index].buttonStatus == true) {
        cource[index].buttonStatus = false;
      } else {
        cource[index].buttonStatus = true;
      }
    });
  }

  @override
  void initState() {
    homecontroller.homeDashboardTrendingDatGetApi();
    super.initState();
    checkLanguage();
  }

  Map<String, dynamic> mplanguage = new HashMap();

  checkLanguage() async {
    String lcode = await PrefData.getLanguage();

    var b = await LanguageCheck.checkLanguage(lcode);
    setState(() {
      mplanguage = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
        body: SafeArea(
      child: Obx(
        () => Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Image(
                            image: const AssetImage("assets/back_arrow.png"),
                            height: 24.h,
                            width: 24.w,
                          )),
                      SizedBox(width: 16.w),
                      Text(
                        mplanguage['trendingc'].toString(),
                        style: TextStyle(fontSize: 24.sp, color: const Color(0XFF000000), fontFamily: 'Gilroy', fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                homecontroller.trendingCoursesDataModel.data != null ? trending_cource_list() : Container(),
              ],
            ),
            if (homecontroller.isloader.value)
              SafeArea(
                top: false,
                bottom: false,
                child: ColoredBox(
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            spreadRadius: 0.1,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      height: 80,
                      width: 80,
                      child: Platform.isIOS
                          ? const CupertinoActivityIndicator(
                              animating: true,
                              color: Color(0XFF503494),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(25),
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                color: Color(0XFF503494),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }

  Widget trending_cource_list() {
    return Expanded(
      flex: 1,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: (homecontroller.trendingCoursesDataModel.data?.courses ?? []).length,
        separatorBuilder: (context, _) => SizedBox(height: 16.h),
        itemBuilder: (context, i) {
          final course = homecontroller.trendingCoursesDataModel.data!.courses![i];
          return GestureDetector(
            onTap: () {
              Get.to(MyCources(), arguments: course.id ?? 0);
            },
            child: Container(
              height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0XFF503494).withOpacity(0.14),
                    offset: const Offset(-4, 5),
                    blurRadius: 16,
                  ),
                ],
                color: const Color(0XFFFFFFFF),
              ),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      width: 140.w,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: ApiConstants.resolvePublicUrl(course.courseThumbnail),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 140.w,
                        height: double.infinity,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.15,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Gilroy',
                              color: const Color(0XFF000000),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Container(
                                height: 28.h,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0XFFFAF4E1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: const AssetImage("assets/staricon.png"),
                                      height: 15.h,
                                      width: 15.w,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "${course.totalRating ?? 0}",
                                      style: TextStyle(
                                        color: const Color(0XFFFFC403),
                                        fontFamily: 'Gilroy',
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              _priceChipForTrendingCourse(course),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _priceChipForTrendingCourse(dynamic course) {
    final bool isFree = (course?.isFree ?? 0) == 1;
    final int? price = course?.price is int ? course.price as int : int.tryParse('${course?.price ?? ''}');
    final int? discounted = _discountedPriceForTrendingCourse(course);

    if (isFree) {
      return _priceChip(text: 'FREE');
    }

    final int? show = discounted ?? price;
    if (show == null) return const SizedBox.shrink();
    return _priceChip(text: '₹$show');
  }

  int? _discountedPriceForTrendingCourse(dynamic course) {
    try {
      final int? price = course?.price is int ? course.price as int : int.tryParse('${course?.price ?? ''}');
      if (price == null) return null;
      if ((course?.isDiscountable ?? 0) != 1) return null;

      final DateTime? start = course?.discountStartAt is DateTime ? course.discountStartAt as DateTime : null;
      final DateTime? end = course?.discountEndAt is DateTime ? course.discountEndAt as DateTime : null;
      final now = DateTime.now();
      if (start != null && now.isBefore(start)) return null;
      if (end != null && now.isAfter(end)) return null;

      final int? discount = course?.discount is int ? course.discount as int : int.tryParse('${course?.discount ?? ''}');
      if (discount == null || discount <= 0) return null;

      final String type = (course?.discountType ?? '').toString().toLowerCase();
      int discounted;
      if (type.contains('percent')) {
        discounted = ((price * (100 - discount)) / 100).round();
      } else {
        discounted = price - discount;
      }
      if (discounted < 0) discounted = 0;
      if (discounted >= price) return null;
      return discounted;
    } catch (_) {
      return null;
    }
  }

  Widget _priceChip({required String text}) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0XFFE5ECFF),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0XFF503494),
          fontFamily: 'Gilroy',
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
