import 'package:flutter/material.dart';
import 'package:inside_chassidus/data/models/inside-data/index.dart';
import 'package:inside_chassidus/routes/secondary-section-route/widgets/index.dart';
import 'package:inside_chassidus/routes/ternary-section-route.dart';
import 'package:inside_chassidus/widgets/inside-navigator.dart';
import 'package:inside_chassidus/widgets/inside-scaffold.dart';
import 'package:inside_chassidus/widgets/section-content-list.dart';

/// Displays contents of a site section. All subsections and lessons.
class SecondarySectionRoute extends StatelessWidget {
  static const String routeName = "/sections";

  final SiteSection section;

  SecondarySectionRoute({this.section});

  @override
  Widget build(BuildContext context) => InsideScaffold(
      insideData: section,
      body: SectionContentList(
          section: section,
          sectionBuilder: (context, section) => InsideNavigator(
              routeName: TernarySectionRoute.routeName,
              data: section,
              child: InsideDataCard(insideData: section)),
          lessonBuiler: (context, lesson) =>
              InsideDataCard(insideData: lesson)));
}