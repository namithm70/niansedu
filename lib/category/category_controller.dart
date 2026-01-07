import 'package:edxera/category/categor_model.dart';
import 'package:edxera/category/category_service.dart';
import 'package:edxera/home/home_main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = <Datum>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSubmitting = false.obs;

  final CategoryService _categoryService = CategoryService();

  // Fetch categories for a given userId
  Future<void> fetchCategories( ) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _categoryService.fetchCategories();
      if (result != null && result.success == true) {
        categories.value = result.data ?? [];
      } else {
        errorMessage.value = result?.message ?? "Failed to fetch categories.";
      }
    } catch (e) {
      errorMessage.value = "Error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle category selection
  void toggleCategorySelection(int categoryId) {
    final index =
        categories.indexWhere((category) => category.id == categoryId);
    if (index != -1) {
      final currentCategory = categories[index];
      currentCategory.isCategorySelected =
          currentCategory.isCategorySelected == 1 ? 0 : 1;
      categories[index] = currentCategory;
    }
  }

  // Get comma-separated category ids for submission
  String getSelectedCategoryIds() {
    final selectedCategories =
        categories.where((category) => category.isCategorySelected == 1);
    return selectedCategories
        .map((category) => category.id.toString())
        .join(',');
  }

  // Submit selected categories to the API
  Future<void> submitCategories() async {
    isSubmitting.value = true;
    errorMessage.value = '';
    try {
      final categoryIds = getSelectedCategoryIds();//1,1,1,
      if (categoryIds.isEmpty) {
        Fluttertoast.showToast(msg: 'No categories selected!');
        return;
      }

      final response =
          await _categoryService.submitCategories( categoryIds);
      if (response != null && response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Categories added successfully!');
        Get.offAll(()=>const HomeMainScreen());


      } else {
        Fluttertoast.showToast(msg: 'Failed to add categories.');
      }
    } catch (e) {
      errorMessage.value = "Error occurred while submitting categories: $e";
      Fluttertoast.showToast(msg: 'Failed to submit categories.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
