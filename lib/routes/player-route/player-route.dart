import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inside_api/models.dart';
import 'package:inside_api/site-service.dart';
import 'package:inside_chassidus/routes/player-route/widgets/index.dart';
import 'package:inside_chassidus/util/chosen-classes/chosen-class-service.dart';
import 'package:inside_chassidus/util/library-navigator/index.dart';
import 'package:inside_chassidus/widgets/media/audio-button-bar.dart';
import 'package:just_audio_service/download-manager/download-manager.dart';
import 'package:just_audio_service/widgets/download-button.dart';

class PlayerRoute extends StatelessWidget {
  static const String routeName = '/library/playerroute';

  final Media media;

  final SiteBoxes _siteBoxes = BlocProvider.getDependency<SiteBoxes>();

  final libraryPositionService =
      BlocProvider.getDependency<LibraryPositionService>();

  PlayerRoute({this.media});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              FutureBuilder<Section>(
                future: _getParent(),
                builder: (context, snapshot) => snapshot.data != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                // Set library position to parent section (or mediasection)
                                libraryPositionService.setActiveItem(media
                                            .closestSectionId ==
                                        media.parentId
                                    ? snapshot.data
                                    : snapshot.data.content.firstWhere((c) =>
                                        c.mediaSection?.id == media.parentId));
                              },
                              icon: Icon(FontAwesomeIcons.chevronDown))
                        ],
                      )
                    : Container(),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _title(context, media),
              )),
            ]),
            _description(context),
            Theme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(size: 30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _favoriteButton(context),
                  DownloadButton(
                    audioUrl: media.source,
                    downloadManager:
                        BlocProvider.getDependency<ForgroundDownloadManager>(),
                  )
                ],
              ),
            ),
            ProgressBar(
              media: media,
            ),
            AudioButtonBar(
              media: media,
            )
          ],
        ),
      );

  Future<SiteDataItem> _getParent() {
    if (media.closestSectionId == null) {
      return null;
    }

    final parent = _siteBoxes.sections.get(media.closestSectionId);
    return parent;
  }

  /// Returns lesson title and media title.
  /// If the media doesn't have a title, just returns lesson title as title.
  List<Widget> _title(BuildContext context, SiteDataItem lesson) {
    if ((media.title?.isNotEmpty ?? false) &&
        (lesson?.title?.isNotEmpty ?? false) &&
        media.title != lesson.title) {
      return [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Text(
            lesson.title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Text(
          media.title,
          style: Theme.of(context).textTheme.headline1,
        )
      ];
    }

    return [
      Text(
        media.title?.isNotEmpty ?? false ? media.title : lesson.title,
        style: Theme.of(context).textTheme.headline6,
      )
    ];
  }

  /// Create scrollable description. This is also rendered when
  /// there isn't any description, because it expands and pushes the player
  /// to the bottom of the screen into a consistant location.
  _description(BuildContext context) => Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              media.description ?? "",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
      );

  Widget _favoriteButton(BuildContext context) {
    final chosenService = BlocProvider.getDependency<ChosenClassService>();

    return chosenService.isFavoriteValueListenableBuilder(
      media.source,
      builder: (context, isFavorite) => Center(
        child: IconButton(
          iconSize: Theme.of(context).iconTheme.size,
          onPressed: () =>
              chosenService.set(source: media, isFavorite: !isFavorite),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}
