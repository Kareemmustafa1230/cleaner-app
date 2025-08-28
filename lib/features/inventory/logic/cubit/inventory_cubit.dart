// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/repo/inventory_repo.dart';
// import '../../data/model/inventory_response.dart';
// import '../state/inventory_state.dart';
//
// class InventoryCubit extends Cubit<InventoryState> {
//   final InventoryRepo _inventoryRepo;
//   Timer? searchTimer;
//
//   InventoryCubit(this._inventoryRepo) : super(const InventoryState.initial());
//
//   int _currentPage = 1;
//   bool _hasMore = true;
//   final List<InventoryItem> _items = [];
//   final List<InventoryItem> _allItems = [];
//
//   List<InventoryItem> get items => _items;
//   bool get hasMore => _hasMore;
//   int get currentPage => _currentPage;
//
//   Future<void> fetchFirstPage() async {
//     emit(const InventoryState.loading());
//     _currentPage = 1;
//     _hasMore = true;
//     _items.clear();
//     await _fetchPage(_currentPage, isFirst: true);
//   }
//
//   Future<void> fetchNextPage() async {
//     if (!_hasMore) return;
//     _currentPage++;
//     await _fetchPage(_currentPage);
//   }
//
//   Future<void> _fetchPage(int page, {bool isFirst = false}) async {
//     final response = await _inventoryRepo.inventory(page.toString());
//
//     response.when(
//       success: (inventoryResponse) async {
//         final newItems = inventoryResponse.data.inventory;
//
//         if (isFirst) {
//           _items.clear();
//           _allItems.clear();
//         }
//
//         _items.addAll(newItems);
//         _allItems.addAll(newItems);
//
//         _hasMore =
//             inventoryResponse.data.pagination.currentPage !=
//                 inventoryResponse.data.pagination.lastPage;
//
//         emit(InventoryState.success(inventoryResponse: inventoryResponse));
//       },
//       failure: (error) {
//         emit(InventoryState.error(error: error.apiErrorModel.message));
//       },
//     );
//   }
//
//   @override
//   Future<void> close() {
//     searchTimer?.cancel();
//     return super.close();
//   }
// }
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/inventory_repo.dart';
import '../state/inventory_state.dart';
import '../../data/model/inventory_response.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepo _inventoryRepo;
  Timer? searchTimer;

  InventoryCubit(this._inventoryRepo)
      : super(const InventoryState.initial());

  int _currentPage = 1;
  bool _hasMore = true;
  final List<InventoryItem> _inventoryItems = [];

  List<InventoryItem> get inventoryItems => _inventoryItems;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> fetchFirstPage() async {
    emit(const InventoryState.loading());
    _currentPage = 1;
    _hasMore = true;
    _inventoryItems.clear();
    await _fetchPage(_currentPage);
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore) return;
    _currentPage++;
    await _fetchPage(_currentPage);
  }

  Future<void> _fetchPage(int page) async {
    final response = await _inventoryRepo.inventory(
      page.toString(),
    );

    response.when(
      success: (inventoryResponse) async {
        final newItems = inventoryResponse.data.inventory;
        print('API returned ${newItems.length} inventory items');
        for (var item in newItems) {
          print('API Item: id=${item.id}, name=${item.name}, price=${item.price}, quantity=${item.quantity}');
        }

        _inventoryItems.addAll(newItems);

        final pagination = inventoryResponse.data.pagination;
        _hasMore = pagination.currentPage < pagination.lastPage;

        emit(InventoryState.success(inventoryResponse: inventoryResponse));
      },
      failure: (error) {
        print('API Error: ${error.apiErrorModel.message}');
        emit(InventoryState.error(error: error.apiErrorModel.message));
      },
    );
  }

  @override
  Future<void> close() {
    searchTimer?.cancel();
    return super.close();
  }
}