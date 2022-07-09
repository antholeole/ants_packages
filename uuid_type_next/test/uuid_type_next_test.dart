import 'package:test/test.dart';
import 'package:uuid_type_next/uuid_type_next.dart';

void main() {
  final String uuidString = 'df6b0478-0b2e-4ee9-8d5e-8c8389617ddb';

  test('Two same uuids should === eachother', () {
    expect(UuidType(uuidString), UuidType(uuidString));
  });

  test('should be able to convert to json', () {
    expect(JsonUuidConverter().toJson(UuidType(uuidString)), uuidString);
  });

  test('should be able to convert from json', () {
    expect(JsonUuidConverter().fromJson(uuidString), UuidType(uuidString));
  });
}
