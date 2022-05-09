//
//  Extensions.swift
//  UIScrollViewDemo
//
//  Created by 黄伯驹 on 2017/11/3.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

public class NotificationNames {
    fileprivate init() {}
}

/// Base class for static user defaults keys. Specialize with value type
/// and pass key name to the initializer to create a key.

public class NotificationName: NotificationNames {
    // TODO: Can we use protocols to ensure ValueType is a compatible type?

    public let _key: String

    public init(_ key: String) {
        self._key = key
        super.init()
    }

    public init(name: NSNotification.Name) {
        self._key = name.rawValue
        super.init()
    }
}

extension NotificationCenter {
    static func postNotification(name: NotificationName, object: Any? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name._key), object: object)
    }
}


extension UIViewController {
    func addObserver(with selector: Selector, name: NSNotification.Name, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }

    func addObserver(with selector: Selector, name: NotificationName, object: Any? = nil) {
        addObserver(with: selector, name: NSNotification.Name(rawValue: name._key), object: object)
    }

    func postNotification(name: NSNotification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }

    func postNotification(name: NotificationName, object: Any? = nil) {
        postNotification(name: NSNotification.Name(rawValue: name._key), object: object)
    }

    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }

    @discardableResult
    func showAlert(actionTitle: String = "确定", title: String? = nil, message: String?, style: UIAlertController.Style = .alert, handle: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        present(alert, animated: true, completion: nil)
        return alert.action(actionTitle, handle)
    }
}

extension UIAlertController {
    @discardableResult
    func action(_ title: String, style: UIAlertAction.Style = .`default`, _ handle: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handle)
        addAction(action)
        return self
    }
}

extension UIColor {
    // 纯色图片
    public func image(size: CGSize, cornerRadius: CGFloat) -> UIImage {
        //        let size = size.flatted
        
        let opaque = (cornerRadius == 0.0)
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(cgColor)
        
        if cornerRadius > 0 {
            let path = UIBezierPath(roundedRect: size.rect, cornerRadius: cornerRadius)
            path.addClip()
            path.fill()
        } else {
            context?.fill(size.rect)
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }

    static var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}

extension UITableView {
    
    /** Resize a tableView header to according to the auto layout of its contents.
     - This method can resize a headerView according to changes in a dynamically set text label. Simply place this method inside viewDidLayoutSubviews.
     - To animate constrainsts, wrap a tableview.beginUpdates and .endUpdates, followed by a UIView.animateWithDuration block around constraint changes.
     */
    func sizeHeaderToFit() {
        guard let headerView = tableHeaderView else {
            return
        }
        let oldHeight = headerView.frame.height
        
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        headerView.frame.size.height = height
        contentSize.height += (height - oldHeight)
        headerView.layoutIfNeeded()
        
    }
    
    func sizeFooterToFit() {
        guard let footerView = tableFooterView else {
            return
        }
        let oldHeight = footerView.frame.height
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        footerView.frame.size.height = height
        contentSize.height += (height - oldHeight)
        footerView.layoutIfNeeded()
    }
}

extension UICollectionViewFlowLayout {
    /// 修正collection布局有缝隙
    func fixSlit(rect: inout CGRect, colCount: CGFloat, space: CGFloat = 0) -> CGFloat {
        let totalSpace = (colCount - 1) * space
        let itemWidth = (rect.width - totalSpace) / colCount
        let fixValue = 1 / UIScreen.main.scale
        var realItemWidth = floor(itemWidth) + fixValue
        if realItemWidth < itemWidth {
            realItemWidth += fixValue
        }
        let realWidth = colCount * realItemWidth + totalSpace
        let pointX = (realWidth - rect.width) / 2
        rect.origin.x = -pointX
        rect.size.width = realWidth
        return (rect.width - totalSpace) / colCount
    }
}

extension UICollectionView {
    func fixSlit(cols: Int, space: CGFloat = 0) -> CGFloat {
        let colCount = CGFloat(cols)
        let totalSpace = (colCount - 1) * space
        let itemWidth = (frame.width - totalSpace) / colCount
        let fixValue = 1 / UIScreen.main.scale
        var realItemWidth = floor(itemWidth) + fixValue
        if realItemWidth < itemWidth {
            realItemWidth += fixValue
        }
        let realWidth = colCount * realItemWidth + totalSpace
        let pointX = (realWidth - frame.width) / 2
        frame.origin.x = -pointX
        frame.size.width = realWidth
        return (frame.width - totalSpace) / colCount
    }
}

extension UIViewController {
    var visibleViewControllerIfExist: UIViewController? {
        
        if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewControllerIfExist
        }
        if let nav = self as? UINavigationController {
            return nav.topViewController?.visibleViewControllerIfExist
        }
        if let tabbar = self as? UITabBarController {
            return tabbar.selectedViewController?.visibleViewControllerIfExist
        }

        if isViewLoaded && view.window != nil {
            return self
        } else {
            print("qmui_visibleViewControllerIfExist:，找不到可见的viewController。self = \(self), view.window = \(String(describing: view.window))")
            return nil
        }
    }
}

extension UIImage {
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
}

extension UIResponder {
    var responderChain: String {
        guard let next = next else {
            return String(describing: self)
        }
        return String(describing: self) + " -> " + next.responderChain
    }
}
