class OAuth {
  String? tokenType;
  int? expiresIn;
  String? accessToken;
  String? refreshToken;
  String? clientId;
  String? scope;

  OAuth({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
    this.clientId,
    this.scope,
  });

  OAuth.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    expiresIn = json['expires_in'] as int?;
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    clientId = json['client_id'];
    scope = json['scope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['client_id'] = clientId;
    if (scope != null) data['scope'] = scope;
    return data;
  }
}
