import 'package:flutter/material.dart';
import 'package:inside_chassidus/data/models/inside-data/index.dart';
import 'package:inside_chassidus/routes/player-route/widgets/index.dart';

class PlayerRoute extends StatelessWidget {
  static const String routeName = 'playerroute';

  final Media media;

  PlayerRoute({this.media});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Lesson>(
        future: media.getLesson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ..._title(context, snapshot.data),
                  if (media.description?.isNotEmpty ?? false)
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        media.description,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),
                  ProgressBar(
                    media: media,
                  ),
                  AudioButtonBar(media: media, lesson: snapshot.data)
                ],
              ),
            );
          }

          return Container();
        },
      ));

  /// Returns lesson title and media title.
  /// If the media doesn't have a title, just returns lesson title as title.
  List<Widget> _title(BuildContext context, Lesson lesson) {
    if ((media.title?.isNotEmpty ?? false) &&
        (lesson?.title?.isNotEmpty ?? false) &&
        media.title != lesson.title) {
      return [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Text(
            lesson.title,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        Text(
          media.title,
          style: Theme.of(context).textTheme.title,
        )
      ];
    }

    return [
      Text(
        media.title?.isNotEmpty ?? false ? media.title : lesson.title,
        style: Theme.of(context).textTheme.title,
      )
    ];
  }
}