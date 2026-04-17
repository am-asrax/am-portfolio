//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:am_portfolio_client/src/date_serializer.dart';
import 'package:am_portfolio_client/src/model/date.dart';

import 'package:am_portfolio_client/src/model/index_indices.dart';
import 'package:am_portfolio_client/src/model/portfolio_analysis.dart';
import 'package:am_portfolio_client/src/model/portfolio_model_v1.dart';
import 'package:am_portfolio_client/src/model/time_interval.dart';

part 'serializers.g.dart';

@SerializersFor([
  IndexIndices,
  PortfolioAnalysis,
  PortfolioModelV1,
  TimeInterval,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(PortfolioModelV1)]),
        () => ListBuilder<PortfolioModelV1>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(IndexIndices)]),
        () => ListBuilder<IndexIndices>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
