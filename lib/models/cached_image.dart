import 'package:hive/hive.dart';

part 'cached_image.g.dart';

@HiveType(typeId: 0)
class CachedImage extends HiveObject {
  @HiveField(0)
  final String key;

  @HiveField(1)
  final List<int> bytes;

  CachedImage({required this.key, required this.bytes});
}
