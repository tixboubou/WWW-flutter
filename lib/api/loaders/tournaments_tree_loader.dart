import 'package:injectable/injectable.dart';
import 'package:what_when_where/api/http/http_client.dart';
import 'package:what_when_where/api/models/tournaments_tree_dto.dart';
import 'package:what_when_where/api/parsers/xml2json_parser.dart';
import 'package:what_when_where/services/background.dart';

abstract class ITournamentsTreeLoader {
  Future<TournamentsTreeDto> get(String id);
}

@lazySingleton
@RegisterAs(ITournamentsTreeLoader)
class TournamentsTreeLoader implements ITournamentsTreeLoader {
  final IHttpClient _httpClient;
  final IXmlToJsonParser _parser;
  final IBackgroundRunnerService _backgroundService;

  TournamentsTreeLoader({
    IHttpClient httpClient,
    IXmlToJsonParser parser,
    IBackgroundRunnerService backgroundService,
  })  : _httpClient = httpClient,
        _parser = parser,
        _backgroundService = backgroundService;

  @override
  Future<TournamentsTreeDto> get(String id) async {
    final data = await _httpClient.get(Uri(path: '/tour/${id ?? ''}/xml'));
    final dto = await _backgroundService.run<TournamentsTreeDto, List<dynamic>>(
        _parseTournamentsTreeDto, [data, _parser]);
    return dto;
  }
}

TournamentsTreeDto _parseTournamentsTreeDto(List<dynamic> args) {
  final data = args[0] as String;
  final parser = args[1] as IXmlToJsonParser;

  final json = parser.toJson(data);
  return TournamentsTreeDto.fromJson(
      json['tournament'] as Map<String, dynamic>);
}
