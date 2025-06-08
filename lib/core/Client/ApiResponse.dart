class ApiResponse<T> {
  int? code;
  String? message;
  List<T>? data;
  T? singleData;
  Pagination? pagination;
  dynamic errors;
  final ApiErrorType? errorType;

  ApiResponse({
    this.code,
    this.message,
    this.data,
    this.singleData,
    this.pagination,
    this.errors,
    this.errorType,
  });

  /// Automatically determines whether `data` is a list or a single object.
  factory ApiResponse.fromJsonAuto(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    dynamic rawData = json['data'];

    var result = ApiResponse<T>(
      code: json['code'],
      message: json['message'],
      data: rawData is List
          ? rawData
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList()
          : null,
      singleData: rawData is Map<String, dynamic> ? fromJsonT(rawData) : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      errors: json['errors'],
    );

    return result;
  }

  /// Helper method to check if the response contains a list.
  bool get hasList => data != null;

  /// Helper method to check if the response contains a single object.
  bool get hasSingle => singleData != null;

  /// Returns `data` as a list or an empty list if it's null.
  List<T> get getList => data ?? [];

  /// Returns `singleData` or throws an error if it's not available.
  T? get getSingle => singleData;
}

class Pagination {
  int? totalItems;
  int? pageSize;
  int? currentPage;
  int? totalPages;

  Pagination({
    this.totalItems,
    this.pageSize,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['totalItems'],
      pageSize: json['pageSize'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}

enum ApiErrorType {
  noInternet,
  timeout,
  unauthorized,
  serverError,
  unknown,
}