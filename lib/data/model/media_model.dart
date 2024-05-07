import 'package:json_annotation/json_annotation.dart';
import 'package:burgan_task/data/model/media_meta_data_model.dart';
part 'media_model.g.dart';

@JsonSerializable()
class Media {
  @JsonKey(name: 'media-metadata')
  List<MediaMetaData>? mediaMetaData;

  Media({
    required this.mediaMetaData,
  });
  factory Media.fromJson(Map<String, dynamic> json) {
    return _$MediaFromJson(json);
  }
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
