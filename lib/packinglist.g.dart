// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packinglist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PackingListItemAdapter extends TypeAdapter<PackingListItem> {
  @override
  final int typeId = 2;

  @override
  PackingListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PackingListItem(
      name: fields[0] as String,
      quantity: fields[3] as int,
      used: fields[4] as int,
      state: fields[5] as PackingListItemStateEnum,
      category: fields[1] as String,
      comment: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PackingListItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.comment)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.used)
      ..writeByte(5)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackingListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PackingListItemStateEnumAdapter
    extends TypeAdapter<PackingListItemStateEnum> {
  @override
  final int typeId = 1;

  @override
  PackingListItemStateEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PackingListItemStateEnum.missing;
      case 1:
        return PackingListItemStateEnum.skipped;
      case 2:
        return PackingListItemStateEnum.packed;
      default:
        return PackingListItemStateEnum.missing;
    }
  }

  @override
  void write(BinaryWriter writer, PackingListItemStateEnum obj) {
    switch (obj) {
      case PackingListItemStateEnum.missing:
        writer.writeByte(0);
        break;
      case PackingListItemStateEnum.skipped:
        writer.writeByte(1);
        break;
      case PackingListItemStateEnum.packed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackingListItemStateEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
