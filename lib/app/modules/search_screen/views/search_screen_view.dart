import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../theme/app_colors.dart';
import '../../detailScreen/views/detail_screen_view.dart';
import '../controllers/search_screen_controller.dart';

class SearchScreenView extends GetView<SearchScreenController> {
  SearchScreenView({Key? key}) : super(key: key);
  @override
  var controller = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          title: const Text('Search'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CupertinoSearchTextField(
                suffixMode: OverlayVisibilityMode.always,
                suffixIcon: const Icon(Icons.search),
                suffixInsets: const EdgeInsets.only(right: 10),
                autofocus: true,
                autocorrect: false,
                placeholder: 'Search for news, topics',
                prefixIcon: const SizedBox(),
                padding: const EdgeInsets.all(16),
                onSubmitted: (value) {
                  // controller.q.value = value;
                  // controller.newArticles.clear();
                  // controller.firstLoad();
                  // controller.isFirstLoad.value=true;
                },
                onChanged: (value)  {
                  controller.onSearchChanged(value);

                  // await Future.delayed(const Duration(seconds: 2), () {
                  //
                  // });
                  //
                  //
                  //   controller.q.value = value;
                  //   debugPrint(
                  //       'display value ->> ${value.toString()} ${DateFormat('hh:mm:ss').format(DateTime.now())}');
                  //   controller.newArticles.clear();
                  //   controller.firstLoad();
                  //   controller.isFirstLoad.value = true;

                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Obx(() => controller.isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.newArticles.isEmpty
                        ? Visibility(
                            visible: controller.isFirstLoad.value,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.text_snippet_outlined,
                                    color: Colors.grey,
                                    size: 200,
                                  ),
                                  Text(
                                    'No result found!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: controller.Fcontroller,
                            itemCount: controller.newArticles.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(const DetailScreenView(),
                                      arguments: controller.newArticles[index]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    height: Get.height*.18,
                                    margin: const EdgeInsets.only(
                                        left: 0, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 4,
                                          spreadRadius: .2,
                                          offset: const Offset(4, 1),
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        controller
                                                                    .newArticles[
                                                                        index]
                                                                    .source
                                                                    ?.name ==
                                                                null
                                                            ? "No Source found"
                                                            : controller
                                                                .newArticles[
                                                                    index]
                                                                .source!
                                                                .name
                                                                .toString(),
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                      controller
                                                                  .newArticles[
                                                                      index]
                                                                  .content ==
                                                              null
                                                          ? "No Data Fetched"
                                                          : controller
                                                              .newArticles[
                                                                  index]
                                                              .content
                                                              .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    )
                                                    //  ),
                                                  ],
                                                )),
                                                controller.newArticles[index]
                                                            .publishedAt ==
                                                        null
                                                    ? const Text('No Time')
                                                    : Text(
                                                        controller.time_ago(
                                                            DateTime.parse(
                                                                controller
                                                                    .newArticles[
                                                                        index]
                                                                    .publishedAt
                                                                    .toString())),
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          controller.newArticles[index]
                                                      .urlToImage ==
                                                  null
                                              ? Container(
                                                  color: Colors.grey.shade100,
                                                  height: 150,
                                                  width: 150,
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    size: 100,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  child: Image.network(
                                                    controller
                                                        .newArticles[index]
                                                        .urlToImage
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height: Get.height*.20,
                                                    width: 150,
                                                    errorBuilder: (_, __, ___) {
                                                      return const SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          size: 100,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
              ),
            ),
          ],
        ));
  }
}
