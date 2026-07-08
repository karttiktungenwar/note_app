import 'dart:convert'; // Required for jsonEncode/jsonDecode
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  // Write methods
  Future<void> writeString(String key, String value);
  Future<void> writeBool(String key, bool value);
  Future<void> writeInt(String key, int value);
  Future<void> writeDouble(String key, double value);
  Future<void> writeObject(String key, Map<String, dynamic> jsonMap);

  // Read methods
  Future<String?> readString(String key);
  Future<bool?> readBool(String key);
  Future<int?> readInt(String key);
  Future<double?> readDouble(String key);
  Future<Map<String, dynamic>?> readObject(String key);

  // Generic deletion
  Future<void> delete(String key);
  Future<void> clearAll();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageServiceImpl(this._secureStorage);

  // --- WRITE METHODS ---

  @override
  Future<void> writeString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  @override
  Future<void> writeInt(String key, int value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  @override
  Future<void> writeDouble(String key, double value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  @override
  Future<void> writeObject(String key, Map<String, dynamic> jsonMap) async {
    final String jsonString = jsonEncode(jsonMap);
    await _secureStorage.write(key: key, value: jsonString);
  }

  // --- READ METHODS ---

  @override
  Future<String?> readString(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<bool?> readBool(String key) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return value == 'true';
  }

  @override
  Future<int?> readInt(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null ? int.tryParse(value) : null;
  }

  @override
  Future<double?> readDouble(String key) async {
    final value = await _secureStorage.read(key: key);
    return value != null ? double.tryParse(value) : null;
  }

  @override
  Future<Map<String, dynamic>?> readObject(String key) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (_) {
      return null; // Handle malformed JSON gracefully
    }
  }

  // --- DELETE METHODS ---

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}