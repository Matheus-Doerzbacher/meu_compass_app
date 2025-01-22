import 'package:freezed_annotation/freezed_annotation.dart';

part 'destination.freezed.dart';

part 'destination.g.dart';

@freezed
class Destination with _$Destination {
  const factory Destination({
    required String ref,
    required String name,
    required String country,
    required String continent,
    required String knownFor,
    required List<String> tags,

    /// e.g. 'https://storage.googleapis.com/tripedia-images/destinations/alaska.jpg'
    required String imageUrl,
  }) = _Destination;

  factory Destination.fromJson(Map<String, Object?> json) =>
      _$DestinationFromJson(json);
}
