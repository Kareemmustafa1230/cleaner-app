import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/apartment_search_response.dart';
part 'apartment_search_state.freezed.dart';

@freezed
class ApartmentSearchState with _$ApartmentSearchState{
  const factory ApartmentSearchState.initial() = _Initial;
  const factory ApartmentSearchState.loading() = Loading;
  const factory ApartmentSearchState.success({required ApartmentSearchResponse apartmentSearchResponse}) = Success;
  const factory ApartmentSearchState.error({required String error}) = Error;

}



