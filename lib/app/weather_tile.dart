import 'package:weather/app/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class WeatherTile extends StatelessWidget {
  final FormattedWeatherData data;
  final String? cityName;
  final double fontSize;
  final Position? position;
  final double? width;
  final double? height;
  final bool isForeCastTile;
  final String? day;
  final EdgeInsets padding;
  final String? time;

  const WeatherTile({
    Key? key,
    required this.data,
    this.cityName,
    this.fontSize = 20,
    this.position,
    this.width,
    this.height,
    this.isForeCastTile = false,
    this.day,
    required this.padding,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = isForeCastTile
        ? theme.textTheme.bodyLarge
        : theme.textTheme.headlineSmall;

    final children = [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.currentTemperature,
            style: style,
          ),
          Text(
            'Feels like: ${data.feelsLike}',
            style: style,
          ),
          Text(
            'Wind: ${data.windSpeed}',
            style: style,
          ),
        ],
      ),
      if (day != null && isForeCastTile)
        Column(
          children: [
            Text(
              day!,
              style: style,
            ),
            if (time != null && isForeCastTile)
              Text(
                time!,
                style: style,
              ),
          ],
        ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          data.icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            data.shortDescription,
            textAlign: TextAlign.center,
            style: style!.copyWith(fontSize: fontSize * 1.5),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      if (cityName != null)
        Text(
          cityName!,
          style: style,
        )
      else if (position != null)
        Text(
          'Position: ${position!.longitude.toString()}, ${position!.latitude.toString()}',
          style: style,
          textAlign: TextAlign.center,
        )
    ];

    var banner = YaruBorderContainer(
      color: data.color.withOpacity(0.1),
      border: Border.all(
        color: theme.dividerColor.withOpacity(0.8),
      ),
      child: Center(
        child: isForeCastTile
            ? Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 40,
                runAlignment: WrapAlignment.center,
                runSpacing: 20,
                children: children,
              )
            : Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 20,
                runSpacing: 20,
                runAlignment: WrapAlignment.center,
                children: children,
              ),
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: padding,
        child: banner,
      ),
    );
  }
}
