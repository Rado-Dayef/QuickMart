import 'package:com.rado.quick_mart/constants/app_colors.dart';
import 'package:com.rado.quick_mart/constants/app_shimmers.dart';
import 'package:com.rado.quick_mart/constants/app_strings.dart';
import 'package:com.rado.quick_mart/controllers/home_controller.dart';
import 'package:com.rado.quick_mart/controllers/home_search_controller.dart';
import 'package:com.rado.quick_mart/models/firebase_services/post_services.dart';
import 'package:com.rado.quick_mart/models/posts_model.dart';
import 'package:com.rado.quick_mart/views/widgets/my_error_icon_widget.dart';
import 'package:com.rado.quick_mart/views/widgets/my_gap_widget.dart';
import 'package:com.rado.quick_mart/views/widgets/my_offline_widget.dart';
import 'package:com.rado.quick_mart/views/widgets/my_post_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class SearchScreen extends GetWidget<HomeSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return connected
            ? Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                    ),
                  ),
                  title: Text(
                    controller.searchFromArgs,
                  ),
                ),
                body: ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    MyGapWidget(10.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: StreamBuilder(
                        stream: PostServices.fetchPostsBasedOnUserSearchInStream(controller.searchFromArgs),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return AppShimmers.masonryGridViewShimmer();
                          } else if (snapshot.hasError) {
                            return MyErrorIconWidget();
                          } else {
                            List<PostsModel> posts = snapshot.data ?? [];
                            if (posts.isNotEmpty) {
                              return MasonryGridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: posts.length >= 20 ? 20 : posts.length,
                                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                crossAxisSpacing: 10.sp,
                                mainAxisSpacing: 10.sp,
                                itemBuilder: (itemBuilder, index) {
                                  PostsModel post = posts[index];
                                  return InkWell(
                                    onTap: () => controller.searchedItemOnClick(post),
                                    child: MyPostItemWidget(homeController, post),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text(
                                  AppStrings.noAdsForSearchMessage,
                                  style: TextStyle(
                                    color: AppColors.darkBlue,
                                    fontSize: 24.sp,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            : MyOfflineWidget();
      },
      child: Center(),
    );
  }
}
