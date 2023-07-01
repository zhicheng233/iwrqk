import 'package:get/get.dart';

import 'controller.dart';

class ThreadBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThreadController>(() => ThreadController());
  }
}
