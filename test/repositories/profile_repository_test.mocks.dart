// Mocks generated by Mockito 5.4.6 from annotations
// in kiwi/test/repositories/profile_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:kiwi/repositories/api_repository.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:supabase_flutter/supabase_flutter.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSupabaseClient_0 extends _i1.SmartFake
    implements _i2.SupabaseClient {
  _FakeSupabaseClient_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [ApiRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiRepository extends _i1.Mock implements _i3.ApiRepository {
  MockApiRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.SupabaseClient get client =>
      (super.noSuchMethod(
            Invocation.getter(#client),
            returnValue: _FakeSupabaseClient_0(
              this,
              Invocation.getter(#client),
            ),
          )
          as _i2.SupabaseClient);

  @override
  _i4.Future<List<Map<String, dynamic>>> fetchList({
    required String? table,
    Map<String, dynamic>? filters,
    int? limit,
    String? orderBy,
    bool? ascending = true,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#fetchList, [], {
              #table: table,
              #filters: filters,
              #limit: limit,
              #orderBy: orderBy,
              #ascending: ascending,
            }),
            returnValue: _i4.Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[],
            ),
          )
          as _i4.Future<List<Map<String, dynamic>>>);

  @override
  _i4.Future<Map<String, dynamic>?> fetchOne({
    required String? table,
    required String? id,
    String? idColumn = 'id',
  }) =>
      (super.noSuchMethod(
            Invocation.method(#fetchOne, [], {
              #table: table,
              #id: id,
              #idColumn: idColumn,
            }),
            returnValue: _i4.Future<Map<String, dynamic>?>.value(),
          )
          as _i4.Future<Map<String, dynamic>?>);

  @override
  _i4.Future<void> insertMany({
    required String? table,
    required List<Map<String, dynamic>>? data,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#insertMany, [], {#table: table, #data: data}),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> insertOne({
    required String? table,
    required Map<String, dynamic>? data,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#insertOne, [], {#table: table, #data: data}),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> updateMany({
    required String? table,
    required List<Map<String, dynamic>>? data,
    required String? idColumn,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#updateMany, [], {
              #table: table,
              #data: data,
              #idColumn: idColumn,
            }),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> updateOne({
    required String? table,
    required String? id,
    required Map<String, dynamic>? data,
    String? idColumn = 'id',
  }) =>
      (super.noSuchMethod(
            Invocation.method(#updateOne, [], {
              #table: table,
              #id: id,
              #data: data,
              #idColumn: idColumn,
            }),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> deleteMany({
    required String? table,
    required List<String>? ids,
    String? idColumn = 'id',
  }) =>
      (super.noSuchMethod(
            Invocation.method(#deleteMany, [], {
              #table: table,
              #ids: ids,
              #idColumn: idColumn,
            }),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> deleteOne({
    required String? table,
    required String? id,
    String? idColumn = 'id',
  }) =>
      (super.noSuchMethod(
            Invocation.method(#deleteOne, [], {
              #table: table,
              #id: id,
              #idColumn: idColumn,
            }),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> login() =>
      (super.noSuchMethod(
            Invocation.method(#login, []),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);
}
