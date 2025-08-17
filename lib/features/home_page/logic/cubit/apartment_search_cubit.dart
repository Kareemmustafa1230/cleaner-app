import 'dart:async';
import 'package:diyar/features/home_page/data/model/apartment_search_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../data/repo/apartment_search_repo.dart';
import '../state/apartment_search_state.dart';

class ApartmentSearchCubit extends Cubit<ApartmentSearchState> {
  final ApartmentSearchRepo _apartmentSearchRepo;
  Timer? searchTimer;

  ApartmentSearchCubit(this._apartmentSearchRepo)
      : super(const ApartmentSearchState.initial());

  int _currentPage = 1;
  bool _hasMore = true;
  final List<Chalets> _chalets = [];
  final List<Chalets> _allChalets = []; // لتخزين البيانات الأصلية
  TextEditingController searchController = TextEditingController();

  List<Chalets> get chalets => _chalets;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> fetchFirstPage() async {
    emit(const ApartmentSearchState.loading());
    _currentPage = 1;
    _hasMore = true;
    await _fetchPage(_currentPage, isFirst: true);
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore) return;
    _currentPage++;
    await _fetchPage(_currentPage);
  }

  Future<void> _fetchPage(int page, {bool isFirst = false}) async {
    final response = await _apartmentSearchRepo.apartmentSearch(
      page.toString(),
      searchController.text,
    );

    response.when(
      success: (apartmentSearchResponse) async{
        final newChalets = apartmentSearchResponse.data?.chalets ?? [];

        if (isFirst) {
          _chalets.clear();
          // تخزين البيانات الأصلية فقط إذا كان البحث فارغاً
          if (searchController.text.isEmpty) {
            _allChalets.clear();
            _allChalets.addAll(newChalets);
          }
        }

        _chalets.addAll(newChalets);

        _hasMore = apartmentSearchResponse.data?.pagination?.currentPage !=
            apartmentSearchResponse.data?.pagination?.lastPage;
        emit(ApartmentSearchState.success(
            apartmentSearchResponse: apartmentSearchResponse));
      },
      failure: (error) {
        emit(ApartmentSearchState.error(error: error.apiErrorModel.message));
      },
    );
  }

  // دالة لتفريغ البحث
  void clearSearch() {
    _chalets.clear();
    _chalets.addAll(_allChalets);
    _hasMore = false; // لا نحتاج لتحميل المزيد لأن البيانات كاملة
    emit(ApartmentSearchState.success(
      apartmentSearchResponse: ApartmentSearchResponse(
        data: Data(chalets: _chalets),
      ),
    ));
  }

  @override
  Future<void> close() {
    searchTimer?.cancel();
    searchController.dispose();
    return super.close();
  }
}
