class Config {
  Config();

  // Config({
  //   required this.type,
  //   required this.projectId,
  //   required this.privateKeyId,
  //   required this.privateKey,
  //   required this.clientEmail,
  //   required this.clientId,
  //   required this.authUri,
  //   required this.tokenUri,
  //   required this.authProviderX509CertUrl,
  //   required this.clientX509CertUrl,
  //   required this.spreadsheetId,
  // });
  late final String type;
  late final String projectId;
  late final String privateKeyId;
  late final String privateKey;
  late final String clientEmail;
  late final String clientId;
  late final String authUri;
  late final String tokenUri;
  late final String authProviderX509CertUrl;
  late final String clientX509CertUrl;
  late final String spreadsheetId;

  Config.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    projectId = json['project_id'];
    privateKeyId = json['private_key_id'];
    privateKey = json['private_key'];
    clientEmail = json['client_email'];
    clientId = json['client_id'];
    authUri = json['auth_uri'];
    tokenUri = json['token_uri'];
    authProviderX509CertUrl = json['auth_provider_x509_cert_url'];
    clientX509CertUrl = json['client_x509_cert_url'];
    spreadsheetId = json['spreadsheet_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['project_id'] = projectId;
    _data['private_key_id'] = privateKeyId;
    _data['private_key'] = privateKey;
    _data['client_email'] = clientEmail;
    _data['client_id'] = clientId;
    _data['auth_uri'] = authUri;
    _data['token_uri'] = tokenUri;
    _data['auth_provider_x509_cert_url'] = authProviderX509CertUrl;
    _data['client_x509_cert_url'] = clientX509CertUrl;
    // _data['spreadsheet_id'] = spreadsheetId;
    return _data;
  }
}
