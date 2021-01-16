class ResponseError {
  ResponseErrorType type;
  String message;
  String description;

  ResponseError.serviceConstructor(this.type, this.message, this.description);

  factory ResponseError.fromJson(Map<String, dynamic> json) {
    return ResponseError.serviceConstructor(
      ResponseErrorType(json['error']) ?? ResponseErrorType.invalidToken,
      json['message'] ?? "",
      json['description'] ?? ""
    );
  }
}

class ResponseErrorType {
  static ResponseErrorType get invalidToken { return ResponseErrorType("invalid_token");}
  static ResponseErrorType get unspecificated { return ResponseErrorType("unspecificated");}
  static ResponseErrorType get unauth { return ResponseErrorType("unauth");}
  static ResponseErrorType get wrongParameters { return ResponseErrorType("wrong_parameters");}
  static ResponseErrorType get sys { return ResponseErrorType("sys");}
  static ResponseErrorType get uncredited { return ResponseErrorType("uncredited");}

  String value;

  ResponseErrorType(this.value);
}