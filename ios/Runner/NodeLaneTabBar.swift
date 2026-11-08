import Flutter
import UIKit

final class NodeLaneTabBarFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger
  init(messenger: FlutterBinaryMessenger) { self.messenger = messenger }
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64,
              arguments args: Any?) -> FlutterPlatformView {
    NodeLaneTabBar(frame: frame, identifier: viewId, arguments: args, messenger: messenger)
  }
}

/// Only the system tab controller is native; Flutter retains route and data ownership.
private final class NodeLaneTabBar: NSObject, FlutterPlatformView, UITabBarControllerDelegate {
  private let host: TabBarHost
  private let channel: FlutterMethodChannel
  private var itemKeys: [String] = []

  init(frame: CGRect, identifier: Int64, arguments: Any?, messenger: FlutterBinaryMessenger) {
    host = TabBarHost(frame: frame)
    channel = FlutterMethodChannel(name: "nodelane/native_tab_bar/\(identifier)",
                                   binaryMessenger: messenger)
    super.init()
    host.controller.delegate = self
    if #available(iOS 26.0, *) { host.controller.tabBarMinimizeBehavior = .never }
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "update" else { result(FlutterMethodNotImplemented); return }
      self?.update(call.arguments)
      result(nil)
    }
    update(arguments)
  }

  func view() -> UIView { host }

  private func update(_ value: Any?) {
    guard let config = value as? [String: Any],
          let items = config["items"] as? [[String: Any]],
          !items.isEmpty, items.count <= 5 else { return }
    let keys = items.map { "\($0["id"] ?? "")|\($0["label"] ?? "")|\($0["symbol"] ?? "")" }
    if keys != itemKeys {
      itemKeys = keys
      host.controller.setViewControllers(items.enumerated().map { index, item in
        let page = UIViewController()
        page.view.backgroundColor = .clear
        let tab = UITabBarItem(title: item["label"] as? String,
          image: UIImage(systemName: item["symbol"] as? String ?? "square.grid.2x2"),
          selectedImage: UIImage(systemName: item["selectedSymbol"] as? String ?? "square.grid.2x2.fill"))
        tab.tag = index
        tab.accessibilityIdentifier = "nodelane.tab.\(item["id"] ?? "")"
        page.tabBarItem = tab
        return page
      }, animated: false)
    }
    for (index, item) in items.enumerated() {
      let badge = item["badge"] as? Int ?? 0
      host.controller.viewControllers?[index].tabBarItem.badgeValue = badge > 0 ? "\(badge)" : nil
    }
    if let selected = config["selected"] as? Int, items.indices.contains(selected) {
      host.controller.selectedIndex = selected
    }
    if let number = config["accent"] as? NSNumber {
      let rgb = number.uint32Value
      host.controller.tabBar.tintColor = UIColor(
        red: CGFloat((rgb >> 16) & 255) / 255,
        green: CGFloat((rgb >> 8) & 255) / 255,
        blue: CGFloat(rgb & 255) / 255, alpha: CGFloat((rgb >> 24) & 255) / 255)
    }
    host.controller.overrideUserInterfaceStyle = config["dark"] as? Bool == true ? .dark : .light
  }

  func tabBarController(_ tabBarController: UITabBarController,
                        shouldSelect viewController: UIViewController) -> Bool {
    if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
      channel.invokeMethod("select", arguments: index)
    }
    // Flutter commits selection after routing (or after an overflow sheet).
    // A cancelled sheet must not leave UIKit displaying the wrong active tab.
    return false
  }

  deinit {
    channel.setMethodCallHandler(nil)
    host.detach()
  }
}

private final class TabBarHost: UIView {
  let controller = UITabBarController()
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    controller.view.backgroundColor = .clear
  }
  required init?(coder: NSCoder) { nil }
  override func didMoveToWindow() {
    super.didMoveToWindow()
    if window == nil { detach(); return }
    attach()
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    attach()
    controller.view.frame = bounds
  }
  private func attach() {
    guard window != nil, controller.parent == nil else { return }
    var responder: UIResponder? = superview
    while let current = responder {
      if let parent = current as? UIViewController {
        parent.addChild(controller)
        addSubview(controller.view)
        controller.view.frame = bounds
        controller.didMove(toParent: parent)
        return
      }
      responder = current.next
    }
  }
  func detach() {
    guard controller.parent != nil else { return }
    controller.willMove(toParent: nil)
    controller.view.removeFromSuperview()
    controller.removeFromParent()
  }
}
