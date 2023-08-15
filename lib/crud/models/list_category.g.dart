// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListCategoryAdapter extends TypeAdapter<ListCategory> {
  @override
  final int typeId = 3;

  @override
  ListCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListCategory(
      categoryName: fields[0] as String,
      isExpanded: fields[2] as bool,
      categoryId: fields[3] as String,
      listsIds: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ListCategory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.categoryName)
      ..writeByte(1)
      ..write(obj.listsIds)
      ..writeByte(2)
      ..write(obj.isExpanded)
      ..writeByte(3)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
