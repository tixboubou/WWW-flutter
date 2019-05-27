import 'package:what_when_where/services/question_parser/question_section_type.dart';
import 'package:what_when_where/utils/extensions.dart';

class QuestionParserHelper {
  static final _instance = QuestionParserHelper._();

  factory QuestionParserHelper() => _instance;

  QuestionParserHelper._();

  static final _speakerNotesMatchers = [
    RegExp(r'\[ведущему:[\s]*[\s\S]*?\]', caseSensitive: false),
    RegExp(r'\[чтецу:[\s]*[\s\S]*?\]', caseSensitive: false),
    RegExp(r'\[Примечание ведущему:[\s]*[\s\S]*?\]', caseSensitive: false),
  ];

  static final _audioMatchers = [
    RegExp(r'\(aud: .*?\)', caseSensitive: false),
  ];

  static final _giveAwayMatchers = [
    RegExp(r'<раздатка>[\s\S]*?<\/раздатка>', caseSensitive: false),
    RegExp(r'\[раздаточный материал: [\s\S]*?\]', caseSensitive: false),
  ];

  static final _imageMatchers = [
    RegExp(r'\(pic: .*?\)', caseSensitive: false),
  ];

  static final _matchers = <QuestionSectionType, Iterable<RegExp>>{
    QuestionSectionType.SpeakerNote: _speakerNotesMatchers,
    QuestionSectionType.GiveAway: _giveAwayMatchers,
    QuestionSectionType.Image: _imageMatchers,
    QuestionSectionType.Audio: _audioMatchers,
  };

  static String removeAll(String text, QuestionSectionType sectionType) {
    if (_matchers.containsKey(sectionType)) {
      for (var matcher in _matchers[sectionType]) {
        text = text.replaceAll(matcher, '');
      }
    }
    return text;
  }

  static QuestionSectionType nextSectionType(String text) =>
      _matchers.keys.firstWhere(
          (key) => _matchers[key].any((matcher) => text.startsWith(matcher)),
          orElse: () => QuestionSectionType.Text);

  static String nextSectionText(
          String text, QuestionSectionType nextSectionType) =>
      nextSectionType != QuestionSectionType.Text
          ? _matchers[nextSectionType]
              .map((matcher) => matcher.stringMatch(text))
              .firstWhere(
                (sectionText) => sectionText != null,
                orElse: () => null,
              )
          : text.substring(0, _nearestSectionIndex(text));

  static int _nearestSectionIndex(String text) {
    final sectionsIndexes = _matchers.values
        .expand((x) => x)
        .map((x) => text.indexOf(x))
        .where((i) => i != -1);
    return sectionsIndexes.isNotEmpty
        ? IterableExtensions.min(sectionsIndexes)
        : null;
  }
}
