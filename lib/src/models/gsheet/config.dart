import 'dart:convert';

class Config {
  String spreadsheetId;

  Config({required this.spreadsheetId});

  Map<String, dynamic> toMap() {
    return {
      'spreadsheet_id': spreadsheetId,
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      spreadsheetId: map['spreadsheet_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Config.fromJson(String source) => Config.fromMap(json.decode(source));
}
