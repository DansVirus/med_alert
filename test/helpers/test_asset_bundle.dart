import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestAssetBundle extends CachingAssetBundle {
  final Map<String, String> fakeAssets;

  TestAssetBundle(this.fakeAssets);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (fakeAssets.containsKey(key)) {
      return fakeAssets[key]!;
    }
    throw FlutterError('Unable to load asset: $key');
  }

  @override
  Future<ByteData> load(String key) {
    // Not needed unless you use load() directly
    throw UnimplementedError();
  }
}
