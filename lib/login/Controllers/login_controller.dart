import 'package:dio/dio.dart';
import 'package:edxera/category/category_view.dart';
import 'package:edxera/login/Models/login_data_model.dart';
import 'package:edxera/repositories/post_repository.dart';
import 'package:edxera/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginControllers extends GetxController {
  RxBool isloader = false.obs;
  PostRepository postRepository = PostRepository();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginApi() async {
    print("login function");
    var deviceids = DateTime.now();

    isloader(true);
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
      'device_token': deviceids.toString()
    };
    try {
      print("login function 1");
      LoginDataModel? classesData = await postRepository.sendLoginData(data);
      print("login function 2");
      if ((classesData?.success ?? false)) {
        //Get.offAll(const HomeMainScreen());
        // Get.to(Verification(emailid: emailController.value.text));
        print("login FFF ${classesData}");
        PrefData.setdeviceToken(deviceids.toString());
        //TODO:- OtpVerification removed
        // Get.offAll(const OtpVerification());
        PrefData.setLogin(true);
        PrefData.setUserId(classesData?.data?.id ?? 0);
        PrefData.setUserPhone(classesData?.data?.phone ?? "0");
        // Get.offAll(const HomeMainScreen());
        Get.offAll(const CategoryGridView());
        Fluttertoast.showToast(msg: classesData?.message ?? "Login successful");
      } else {
        Fluttertoast.showToast(msg: classesData?.message ?? "Login failed");
      }
    } on DioException catch (ex) {
      Fluttertoast.showToast(msg: ex.message ?? "Login failed");
    } catch (ex) {
      // Catch non-Dio errors (e.g. TypeError) so loader can't spin forever
      Fluttertoast.showToast(msg: "Login failed");
    } finally {
      isloader(false);
    }
  }
}
