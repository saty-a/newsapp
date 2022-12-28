import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:starter/app/data/models/dto/filter.dart';
import 'dart:developer' as developer;
import 'package:starter/app/data/models/response/newsapi.dart';
import 'package:starter/app/data/repository/news_api_repository.dart';
import 'package:starter/app/data/values/env.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../data/models/dto/response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NewHomeController extends GetxController {
  //TODO: Implement NewHomeController

  var isLoading = true.obs;
  var isFilter = false.obs;
  RxBool isInternetConnected=true.obs;

  //bottom sheet filter with checkbox functionality
  RxList ischeck = [].obs;
  RxString sourcesIds = ''.obs;

  List<dynamic>? articles;
  Set<dynamic> sources = {};
  Set<dynamic> ids = {};

  void sourceList() {
    articles = response?.data?.articles;
    for (int i = 0; i < articles!.length; i++) {
      if (articles![i].source.id != null &&
          !(ids.contains(articles![i].source.id))) {
        sources.add(articles![i].source.name);
        ids.add(articles![i].source.id.toString());
        ischeck.add(false);
      }
    }
  }

  void filterByNews() {
    sourcesIds.value = '';
    for (int i = 0; i < ids.length; i++) {
      if (ischeck[i] == true) {
        sourcesIds.value += '${ids.elementAt(i)},';
      }
    }
    for (int i = 0; i < ids.length; i++) {
      ischeck[i] = false;
    }
  }

  int sourceStringlength() {
    return sourcesIds.value.length;
  }

  RepoResponse<NewsApiResponse>? response;

  // Filter by sources
  // var sources = 'bbc-news'.obs;

  // Time format
  // "publishedAt": "2022-12-20T07:08:00Z",
  String time_ago(DateTime dt) {
    return timeago.format(dt, allowFromNow: true, locale: 'en');
  }

  //Sorting variables
  var sort = 'newest'.obs;

  // for Location Info
  var initCountry = 'USA'.obs;

  //filter by country news
  RxString countryCode = 'us'.obs;

  ///var url='${Env.baseNewsLink}$countryCode&category=business&apiKey=${Env.apikey}'.obs;
  var url = '${Env.baseNewsLink}us&apiKey=${Env.apikey}'.obs;

  final NewsAppRepository _appRepository = NewsAppRepository();
  RxList<Articles> newArticles = <Articles>[].obs;
  RxList<Source> newsSource = <Source>[].obs;

  ///for Drop Down button Sort
  var sortList = ['Newest', 'Popular', 'Oldest'];
  var selectedDrowpdown = 'Newest'.obs;

  void setCountry(var value) {
    initCountry.value = value;
  }

  /// Function to change Url
  void changeUrlFunction() {
    url.value =
        '${Env.baseNewsLink}country=${countryCode.value}&apiKey=${Env.apikey}';
  }

  void filterUrlFunction() {
    url.value =
        '${Env.baseNewsLink}sources=${sourcesIds.value}&apiKey=${Env.apikey}';
    filterByNews();
  }

  void setCountryCode(var value) {
    countryCode.value = value;
  }

  String getCountry() {
    return initCountry.value;
  }

  void displayCountryCode() {
    displayCountry(initCountry.value);
  }

  Future<void> getNewsList() async {
    try {
      if (isFilter == false) {
        changeUrlFunction();
      } else {
        filterUrlFunction();
        debugPrint(sourcesIds.value);
      }
      debugPrint("Changed Url Here ===>>  $url");
      response = await _appRepository.fetchNewsAPI(url.value);
      if (response?.error == null) {
        isInternetConnected.value = true;
        newArticles.value = response!.data!.articles!;
      } else if (response?.error != null) {
        isInternetConnected.value = response!.error!.noInternet;
      }
    } finally {
      debugPrint("No Data Found");
      isLoading(false);
    }
    debugPrint('Connectivity value :${isInternetConnected.value}');
  }

/*  List_of_ISO_3166_country_codes
*   india - in
*   USA - us
*   Australia - au
*   Brazil - br
*   Sweden  - SE
*   England - gb
* */
// display top headlines ac to country
  void displayCountry(var value) {
    switch (value) {
      case 'India':
        setCountryCode('in');
        break;
      case 'USA':
        setCountryCode('us');
        break;
      case 'Australia':
        setCountryCode('au');
        break;
      case 'Brazil':
        setCountryCode('br');
        break;
      case 'England':
        setCountryCode('gb');
        break;
      case 'Sweden':
        setCountryCode('se');
        break;
      default:
        print('No Country Selected');
    }
  }

  //Selecting value from dropDown Button Sort
  void setSelected(String value) {
    selectedDrowpdown.value = value;
  }

  @override
  void onInit() {
    getNewsList();
    print('connection status :${isInternetConnected.value.toString()}');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
