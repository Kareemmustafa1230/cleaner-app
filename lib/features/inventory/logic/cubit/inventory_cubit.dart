import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/inventory_repo.dart';
import '../../data/model/inventory_response.dart';
import '../state/inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepo _inventoryRepo;
  Timer? searchTimer;

  InventoryCubit(this._inventoryRepo) : super(const InventoryState.initial());

  int _currentPage = 1;
  bool _hasMore = true;
  final List<InventoryItem> _items = [];
  final List<InventoryItem> _allItems = [];

  List<InventoryItem> get items => _items;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> fetchFirstPage() async {
    emit(const InventoryState.loading());
    _currentPage = 1;
    _hasMore = true;
    _items.clear();
    await _fetchPage(_currentPage, isFirst: true);
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore) return;
    _currentPage++;
    await _fetchPage(_currentPage);
  }

  Future<void> _fetchPage(int page, {bool isFirst = false}) async {
    final response = await _inventoryRepo.inventory(page.toString());

    response.when(
      success: (inventoryResponse) async {
        final newItems = inventoryResponse.data.inventory;

        if (isFirst) {
          _items.clear();
          _allItems.clear();
        }

        _items.addAll(newItems);
        _allItems.addAll(newItems);

        _hasMore =
            inventoryResponse.data.pagination.currentPage !=
                inventoryResponse.data.pagination.lastPage;

        emit(InventoryState.success(inventoryResponse: inventoryResponse));
      },
      failure: (error) {
        emit(InventoryState.error(error: error.apiErrorModel.message));
      },
    );
  }

  /// تفريغ البحث وإرجاع البيانات الأصلية
  void clearSearch() {
    _items.clear();
    _items.addAll(_allItems);
    _hasMore = false; // البيانات كلها متخزنة
    emit(
      InventoryState.success(
        inventoryResponse: InventoryResponse(
          data: InventoryData(
            inventory: _items,
            searchResultsCount: _items.length,
            pagination: Pagination(
              currentPage: 1,
              lastPage: 1,
              perPage: _items.length,
              total: _items.length,
              from: 1,
              to: _items.length,
            ),
          ),
          message: "تم جلب المخزون بنجاح",
          status: 200,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    searchTimer?.cancel();
    return super.close();
  }
}
