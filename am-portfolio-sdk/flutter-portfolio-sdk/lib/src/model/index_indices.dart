//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'index_indices.g.dart';

/// IndexIndices
///
/// Properties:
/// * [key] 
/// * [index] 
/// * [indexSymbol] 
/// * [timestamp] 
@BuiltValue()
abstract class IndexIndices implements Built<IndexIndices, IndexIndicesBuilder> {
  @BuiltValueField(wireName: r'key')
  String? get key;

  @BuiltValueField(wireName: r'index')
  String? get index;

  @BuiltValueField(wireName: r'indexSymbol')
  String? get indexSymbol;

  @BuiltValueField(wireName: r'timestamp')
  DateTime? get timestamp;

  IndexIndices._();

  factory IndexIndices([void updates(IndexIndicesBuilder b)]) = _$IndexIndices;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IndexIndicesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IndexIndices> get serializer => _$IndexIndicesSerializer();
}

class _$IndexIndicesSerializer implements PrimitiveSerializer<IndexIndices> {
  @override
  final Iterable<Type> types = const [IndexIndices, _$IndexIndices];

  @override
  final String wireName = r'IndexIndices';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IndexIndices object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.key != null) {
      yield r'key';
      yield serializers.serialize(
        object.key,
        specifiedType: const FullType(String),
      );
    }
    if (object.index != null) {
      yield r'index';
      yield serializers.serialize(
        object.index,
        specifiedType: const FullType(String),
      );
    }
    if (object.indexSymbol != null) {
      yield r'indexSymbol';
      yield serializers.serialize(
        object.indexSymbol,
        specifiedType: const FullType(String),
      );
    }
    if (object.timestamp != null) {
      yield r'timestamp';
      yield serializers.serialize(
        object.timestamp,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    IndexIndices object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IndexIndicesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'index':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.index = valueDes;
          break;
        case r'indexSymbol':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.indexSymbol = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IndexIndices deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IndexIndicesBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

