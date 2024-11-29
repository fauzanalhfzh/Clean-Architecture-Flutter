import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/core/error/exception.dart';
import 'package:test/features/profile/data/datasources/remote_datasource.dart';
import 'package:test/features/profile/data/models/profile_model.dart';

@GenerateNiceMocks(
    [MockSpec<ProfileRemoteDataSource>(), MockSpec<http.Client>()])
import 'remote_datasource_test.mocks.dart';

void main() async {
  var remoteDataSource = MockProfileRemoteDataSource();
  MockClient mockClient = MockClient();
  var remoteDataSourceImplementation =
      ProfileRemoteDataSourceImplementation(client: mockClient);

  const int userId = 1;
  const int page = 1;

  Uri urlGetUserById = Uri.parse("https://reqres.in/api/users/$userId");
  Uri urlGetAllUser = Uri.parse("https://reqres.in/api/users?page=$page");

  Map<String, dynamic> fakeDataJson = {
    "id": userId,
    "email": "user1@gmail.com",
    "first_name": "user",
    "last_name": "$userId",
    "avatar": "https://image.com/$userId"
  };

  ProfileModel fakeProfileModel = ProfileModel.fromJson(fakeDataJson);

  group('Profile Remote Data Source Abstract', () {
    group('getUserById()', () {
      test('BERHASIL', () async {
        when(remoteDataSource.getUserById(userId)).thenAnswer(
          (_) async => fakeProfileModel,
        );

        try {
          var response = await remoteDataSource.getUserById(userId);
          expect(response, fakeProfileModel);
        } catch (e) {
          fail("Tidak akan mungkin terjadi error");
        }
      });

      test('GAGAL', () async {
        when(remoteDataSource.getUserById(userId)).thenThrow(Exception());

        try {
          fail("Tidak akan mungkin terjadi error");
        } catch (e) {
          expect(e, isException);
        }
      });
    });

    group('getAllUser()', () {
      test('BERHASIL', () async {
        when(remoteDataSource.getAllUser(page)).thenAnswer(
          (_) async => [fakeProfileModel],
        );

        try {
          var response = await remoteDataSource.getAllUser(page);
          expect(response, [fakeProfileModel]);
        } catch (e) {
          fail("Tidak akan mungkin terjadi error");
        }
      });
      test('GAGAL', () async {
        when(remoteDataSource.getAllUser(page)).thenThrow(Exception());

        try {
          fail("Tidak akan mungkin terjadi error");
        } catch (e) {
          expect(e, isException);
        }
      });
    });
  });

  group('Profile Remote Data Source Implementation', () {
    group('getUserById()', () {
      test('BERHASIL (200)', () async {
        when(mockClient.get(urlGetUserById)).thenAnswer(
          (_) async => http.Response(
              jsonEncode({
                "data": fakeDataJson,
              }),
              200),
        );

        try {
          var response =
              await remoteDataSourceImplementation.getUserById(userId);
          expect(response, fakeProfileModel);
        } catch (e) {
          fail("Tidak akan mungkin terjadi");
        }
      });

      test('GAGAL (404)', () async {
        when(mockClient.get(urlGetUserById)).thenAnswer(
          (_) async => http.Response(jsonEncode({}), 404),
        );

        expect(
          () async => await remoteDataSourceImplementation.getUserById(userId),
          throwsA(isA<EmptyException>()),
        );
      });

      test('GAGAL (500)', () async {
        when(mockClient.get(urlGetUserById)).thenAnswer(
          (_) async => http.Response(jsonEncode({}), 500),
        );

        try {
          fail("Tidak akan mungkin terjadi");
        } on EmptyException {
          fail("Tidak akan mungkin terjadi");
        } catch (e) {
          expect(e, isException);
        }
      });
    });

    group('getAllUser', () {
      test('BERHASIL (200)', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
              jsonEncode({
                "data": [fakeDataJson],
              }),
              200),
        );

        try {
          var response = await remoteDataSourceImplementation.getAllUser(page);
          expect(response, [fakeProfileModel]);
        } catch (e) {
          fail("Tidak akan mungkin terjadi");
        }
      });

      test('GAGAL (empty)', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(jsonEncode({"data": []}), 200),
        );

        try {
          await remoteDataSourceImplementation.getAllUser(page);
          fail("Tidak akan mungkin terjadi");
        } on EmptyException catch (e) {
          expect(e, isException);
        } on StatusCodeException {
          fail("Tidak akan mungkin terjadi");
        } catch (e) {
          fail("Tidak akan mungkin terjadi");
        }
      });

      test('GAGAL (404)', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(jsonEncode({}), 404),
        );

        try {
          await remoteDataSourceImplementation.getAllUser(page);
          fail("Tidak akan mungkin terjadi");
        } on EmptyException {
          fail("Tidak akan mungkin terjadi");
        } on StatusCodeException catch (e) {
          expect(e, isException);
        } catch (e) {
          fail("Tidak akan mungkin terjadi");
        }
      });

      test('GAGAL (500)', () async {
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(jsonEncode({}), 500),
        );

        try {
          await remoteDataSourceImplementation.getAllUser(page);
          fail("Tidak akan mungkin terjadi");
        } on EmptyException {
          fail("Tidak akan mungkin terjadi");
        } on StatusCodeException {
          fail("Tidak akan mungkin terjadi");
        } catch (e) {
          expect(e, isException);
        }
      });
    });
  });
}
