import 'package:json_annotation/json_annotation.dart';

part 'media_meta_data_model.g.dart';

@JsonSerializable()
class MediaMetaData {
  String url;
  String format;
  int height;
  int width;

  MediaMetaData({
    required this.url,
    required this.format,
    required this.height,
    required this.width,
  });
  factory MediaMetaData.fromJson(Map<String, dynamic> json) {
    return _$MediaMetaDataFromJson(json);
  }
  Map<String, dynamic> toJson() => _$MediaMetaDataToJson(this);
}
