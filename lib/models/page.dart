import 'package:mangayomi/eval/http_response_extensions.dart';
import 'package:mangayomi/models/source_image_processing.dart';

class PageUrl {
  String url;
  String? fileName;
  Map<String, String>? headers;
  SourceImageProcessing? imageProcessing;

  PageUrl(this.url, {this.fileName, this.headers, this.imageProcessing});
  factory PageUrl.fromJson(Map<String, dynamic> json) {
    return PageUrl(
      json['url'].toString().trim(),
      fileName: json['fileName'] as String?,
      headers: (json['headers'] as Map?)?.toMapStringString,
      imageProcessing: json['imageProcessing'] == null
          ? null
          : SourceImageProcessing.fromJson(
              Map<String, dynamic>.from(json['imageProcessing'] as Map),
            ),
    );
  }
  Map<String, dynamic> toJson() => {
    'url': url,
    'headers': headers,
    'fileName': fileName,
    if (imageProcessing != null) 'imageProcessing': imageProcessing!.toJson(),
  };

  @override
  String toString() {
    return 'PageUrl(url: $url, headers: $headers, fileName: $fileName)';
  }
}
