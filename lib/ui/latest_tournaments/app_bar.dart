import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_when_where/resources/style_configuration.dart';
import 'package:what_when_where/ui/latest_tournaments/app_bar_buttons/more.dart';
import 'package:what_when_where/ui/latest_tournaments/app_bar_buttons/random.dart';
import 'package:what_when_where/ui/latest_tournaments/app_bar_buttons/search.dart';
import 'package:what_when_where/ui/latest_tournaments/app_bar_buttons/tree.dart';

class LatestTournamentsAppBar extends StatelessWidget {
  const LatestTournamentsAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleConfiguration =
        StyleConfiguration.of(context).latestTournamentsStyleConfiguration;

    return SliverAppBar(
      floating: true,
      snap: true,
      expandedHeight: styleConfiguration.appBarHeight,
      flexibleSpace: FlexibleSpaceBar(
        title: Hero(
          tag: 'owl',
          child: SvgPicture.asset(
            'assets/owl.svg',
            height: styleConfiguration.appBarLogoHeight,
            color: styleConfiguration.appBarIconTheme.color,
          ),
        ),
        centerTitle: false,
      ),
      bottom: PreferredSize(
        child: IconTheme.merge(
          data: styleConfiguration.appBarIconTheme,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              LatestTournamentsAppBarTreeButton(),
              LatestTournamentsAppBarRandomButton(),
              LatestTournamentsAppBarSearchButton(),
              LatestTournamentsAppBarMoreButton()
            ],
          ),
        ),
        preferredSize: Size.fromHeight(
          styleConfiguration.appBarBottomHeight,
        ),
      ),
    );
  }
}
