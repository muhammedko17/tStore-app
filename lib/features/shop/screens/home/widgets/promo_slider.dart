import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/common/widgets/images/t_image.dart';
import 'package:t_utils/utils/constants/enums.dart';

import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/banner_controller.dart';

/// Widget to display a promo slider using GetX state management.
class TPromoSlider extends StatelessWidget {
  const TPromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    // Get instance of BannerController using GetX
    final controller = Get.put(BannerController());

    // Use Obx widget to automatically rebuild the UI when banners state changes
    return Obx(
      () {
        // Loader
        if (controller.bannersLoading.value) return const TShimmerEffect(width: double.infinity, height: 190);

        // No data found
        if (controller.banners.isEmpty) {
          return const Center(child: Text('No Promotions Available!'));
        } else {
          /// Record Found! 🎊
          // Display CarouselSlider with banners and page indicator
          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                  onPageChanged: (index, _) => controller.updatePageIndicator(index),
                ),
                items: controller.banners
                    .map(
                      (banner) => GestureDetector(
                        onTap: () {
                          controller.updateClickValue(banner);
                          controller.onBannerClick(banner);
                        },
                        child: TImage(
                          image: banner.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          padding: 0,
                          applyImageRadius: false,
                          imageType: ImageType.network,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Display page indicators based on the number of banners
                      for (int i = 0; i < controller.banners.length; i++)
                        TCircularContainer(
                          width: 20,
                          height: 4,
                          margin: const EdgeInsets.only(right: 10),
                          backgroundColor: controller.carousalCurrentIndex.value == i ? TColors.primary : TColors.grey,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
