import 'dart:core';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'index.dart';

part 'media.g.dart';

@HiveType()
@JsonSerializable(fieldRename: FieldRename.pascal)
class Media implements InsideDataBase {
  @HiveField(3)
  final String source;

  @HiveField(5)
  String lessonId;

  Future<Lesson> getLesson() async {
    final Lesson lesson = await (Hive.box("lessons") as LazyBox).get(lessonId);
    return lesson;
  }

  Media({this.source, this.title, this.description, this.lessonId, this.pdf});

  @HiveField(0)
  @override
  String description;

  @HiveField(1)
  @override
  List<String> pdf;

  @HiveField(2)
  @override
  String title;

  Duration get duration {
    _milliseconds != null ? Duration(milliseconds: _milliseconds) : null;
  }

  set duration(Duration d) => _milliseconds = d?.inMilliseconds;

  @HiveField(4)
  int _milliseconds;

  /// Returns a media item which is self standing; if it doesn't have its own title, use title of the lesson.
  Media resolve(Lesson lesson) {
    final title = (this.title?.isEmpty ?? true) ? lesson.title : this.title;
    final description = (this.description?.isEmpty ?? true)
        ? lesson.description
        : this.description;
    return Media(title: title, description: description, source: source, lessonId: lessonId);
  }

  bool operator==(dynamic other) => other is Media && other.source == source;

  int get hashCode => source.hashCode;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}