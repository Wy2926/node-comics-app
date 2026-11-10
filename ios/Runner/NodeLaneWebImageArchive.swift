import Flutter
import Foundation

/// WebKit's archive contains the original response bodies, including images
/// which page JavaScript cannot export through a cross-origin canvas.
enum NodeLaneWebImageArchive {
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "nodelane/web_image_archive", binaryMessenger: messenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "extract" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let arguments = call.arguments as? [String: Any],
            let archive = arguments["archive"] as? String,
            let destinations = arguments["destinations"] as? [String: String] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: nil, details: nil))
        return
      }
      DispatchQueue.global(qos: .userInitiated).async {
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: archive), options: .mappedIfSafe)
          guard let root = try PropertyListSerialization.propertyList(
            from: data, options: [], format: nil
          ) as? [String: Any] else {
            throw CocoaError(.propertyListReadCorrupt)
          }
          var resources = root["WebSubresources"] as? [[String: Any]] ?? []
          if let main = root["WebMainResource"] as? [String: Any] { resources.append(main) }
          for resource in resources {
            guard let url = resource["WebResourceURL"] as? String,
                  let path = destinations[url],
                  let bytes = resource["WebResourceData"] as? Data else { continue }
            try bytes.write(to: URL(fileURLWithPath: path), options: .atomic)
          }
          DispatchQueue.main.async { result(nil) }
        } catch {
          // No source addresses, cookies, or document contents in logs/errors.
          DispatchQueue.main.async {
            result(FlutterError(code: "ARCHIVE_UNAVAILABLE", message: nil, details: nil))
          }
        }
      }
    }
  }
}
