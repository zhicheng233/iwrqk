import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/offline/search_history.dart';
import '../../../data/providers/storage_provider.dart';

class NormalSearchController extends GetxController {
  final int maxExpandedClipsCount = 15;
  final RxBool _clipsExpanded = false.obs;
  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final RxBool _showSearchSuffix = false.obs;

  final RxList<SearchHistoryModel> _searchHistoryList =
      <SearchHistoryModel>[].obs;

  bool get clipsExpanded => _clipsExpanded.value;
  bool get showSearchSuffix => _showSearchSuffix.value;

  set showSearchSuffix(bool value) {
    _showSearchSuffix.value = value;
  }

  List<SearchHistoryModel> get searchHistoryList => _searchHistoryList;

  @override
  void onInit() {
    super.onInit();
    _refreshSearchHistoryList();
  }

  void _refreshSearchHistoryList() {
    List<SearchHistoryModel> list = StorageProvider.searchHistoryList;
    if (list.length <= maxExpandedClipsCount) {
      _clipsExpanded.value = true;
    } else {
      _clipsExpanded.value = false;
    }
    _searchHistoryList.value = list;
  }

  Future<void> addSearchHistoryItem(String text) async {
    SearchHistoryModel newItem =
        SearchHistoryModel(keyword: text, source: SearchSource.offical);
    await StorageProvider.addSearchHistoryItem(newItem);
    _refreshSearchHistoryList();
  }

  Future<void> deleteSearchHistoryItem(int index) async {
    await StorageProvider.deleteSearchHistoryItem(index);
    _refreshSearchHistoryList();
  }

  Future<void> clearSearchHistoryList() async {
    await StorageProvider.cleanSearchHistoryList();
    _refreshSearchHistoryList();
  }

  void onSearchTextChanged(String text) {
    _showSearchSuffix.value = text.isNotEmpty;
  }

  void clearSearchText() {
    searchEditingController.clear();
    _showSearchSuffix.value = false;
  }

  void toggleClipsExpanded() {
    _clipsExpanded.value = !_clipsExpanded.value;
  }
}
