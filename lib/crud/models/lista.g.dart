// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListaAdapter extends TypeAdapter<Lista> {
  @override
  final int typeId = 1;

  @override
  Lista read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lista(
      title: fields[0] as String,
      creationDate: fields[1] as DateTime,
      items: (fields[2] as List).cast<Item>(),
      id: fields[3] as String,
      categoryId: fields[5] as String?,
      colorSchemeId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Lista obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.creationDate)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.colorSchemeId)
      ..writeByte(5)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
