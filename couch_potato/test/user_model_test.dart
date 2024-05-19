import 'package:flutter_test/flutter_test.dart';
import '../lib/classes/user.dart';

void main() {
  group('UserModel', () {
    test('should create a UserModel with given values', () {
      final user = UserModel(
        id: '123',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(user.id, '123');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
    });

    test('should create a UserModel with null values', () {
      final user = UserModel();

      expect(user.id, isNull);
      expect(user.email, isNull);
      expect(user.displayName, isNull);
    });
  });
}
