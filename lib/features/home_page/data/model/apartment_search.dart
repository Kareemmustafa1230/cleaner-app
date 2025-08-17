import 'package:hive/hive.dart';
import 'apartment_search_response.dart';

class ApartmentSearchResponseAdapter extends TypeAdapter<ApartmentSearchResponse> {
  @override
  final int typeId = 0;

  @override
  ApartmentSearchResponse read(BinaryReader reader) {
    return ApartmentSearchResponse(
      data: reader.read(),
      message: reader.read(),
      status: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ApartmentSearchResponse obj) {
    writer.write(obj.data);
    writer.write(obj.message);
    writer.write(obj.status);
  }
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 4;

  @override
  Data read(BinaryReader reader) {
    final chaletsList = reader.read() as List<dynamic>?; // عملنا cast
    return Data(
      chalets: chaletsList?.cast<Chalets>(), // تحويل كل عنصر لـ Chalets
      searchResultsCount: reader.read(),
      pagination: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer.write(obj.chalets);
    writer.write(obj.searchResultsCount);
    writer.write(obj.pagination);
  }
}

class ChaletsAdapter extends TypeAdapter<Chalets> {
  @override
  final int typeId = 8;

  @override
  Chalets read(BinaryReader reader) {
    return Chalets(
      id: reader.read(),
      name: reader.read(),
      code: reader.read(),
      floor: reader.read(),
      building: reader.read(),
      location: reader.read(),
      description: reader.read(),
      status: reader.read(),
      type: reader.read(),
      isCleaned: reader.read(),
      isBooked: reader.read(),
      image: reader.read(),
      imagesCount: reader.read(),
      createdAt: reader.read(),
      updatedAt: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Chalets obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.code);
    writer.write(obj.floor);
    writer.write(obj.building);
    writer.write(obj.location);
    writer.write(obj.description);
    writer.write(obj.status);
    writer.write(obj.type);
    writer.write(obj.isCleaned);
    writer.write(obj.isBooked);
    writer.write(obj.image);
    writer.write(obj.imagesCount);
    writer.write(obj.createdAt);
    writer.write(obj.updatedAt);
  }
}

class PaginationAdapter extends TypeAdapter<Pagination> {
  @override
  final int typeId = 24;

  @override
  Pagination read(BinaryReader reader) {
    return Pagination(
      currentPage: reader.read(),
      lastPage: reader.read(),
      perPage: reader.read(),
      total: reader.read(),
      from: reader.read(),
      to: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Pagination obj) {
    writer.write(obj.currentPage);
    writer.write(obj.lastPage);
    writer.write(obj.perPage);
    writer.write(obj.total);
    writer.write(obj.from);
    writer.write(obj.to);
  }
}
