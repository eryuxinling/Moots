//
//  JokeController.swift
//  URLSession
//
//  Created by 伯驹 黄 on 2017/2/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import Alamofire
import SwiftyJSON

fileprivate let font = UIFont.systemFont(ofSize: 20)

class Cell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        /*
         在这里打个断点，在lldb中用
         frame variable self
         就可以得到
         "_defaultMarginWidth = 16"
         */
        //        print(value(forKey: "_defaultMarginWidth"))
    }
}

class JokeController: UITableViewController {

    override var canBecomeFirstResponder: Bool {
        return true
    }

    var contents: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var isLoadingMore = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "段子"

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView?.register(Cell.self, forCellReuseIdentifier: "cell")

        tableView.headerRefresher() { headerView in
            self.isLoadingMore = false
            self.getForUrl()
            headerView.stopRefreshing()
        }

        tableView.footerRefresher { footerView in
            self.isLoadingMore = true
            self.getForUrl()
            footerView.stopRefreshing()
        }

        navigationController?.navigationBar.barTintColor = Constants.backgroundColor
        tabBarController?.tabBar.barTintColor = Constants.backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(moreAction))
    }

    @objc func moreAction() {
        let vc = ViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    let reach = NetworkReachabilityManager()

    func AlamofireNetWork() {
        let isReachable = self.reach?.isReachable ?? false

        let cachePolicy: URLRequest.CachePolicy = isReachable ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad

        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 1)
        request.addValue("private", forHTTPHeaderField: "Cache-Control")

        Alamofire.request(request).responseJSON { [unowned self](data) in
            guard let value = data.value else { return }
            if let json = JSON(value).dictionaryValue["段子"] {
                let data = json.arrayValue.compactMap { $0.dictionaryValue["digest"]?.stringValue }
                if self.isLoadingMore {
                    self.contents.append(contentsOf: data)
                } else {
                    self.contents.insert(contentsOf: data, at: 0)
                }
            }
        }
    }

    func getForUrl() {
        AlamofireNetWork()
        //        urlsessionNetwork()
    }

    func urlsessionNetwork() {
        DispatchQueue.global(qos: .background).async {
            // 网络状态
            let isReachable = self.reach?.isReachable ?? false

            let session = URLSession.shared
            /*
             * useProtocolCachePolicy 对特定的 URL 请求使用网络协议中实现的缓存逻辑。这是默认的策略。
             * reloadIgnoringLocalCacheData	 数据需要从原始地址加载。不使用现有缓存。
             * reloadIgnoringLocalAndRemoteCacheData*	 不仅忽略本地缓存，同时也忽略代理服务器或其他中间介质目前已有的、协议允许的缓存。
             * returnCacheDataElseLoad	 无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据。
             * returnCacheDataDontLoad	 无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么放弃从原始地址加载数据，请求视为失败（即：“离线”模式）。
             * reloadRevalidatingCacheData*	从原始地址确认缓存数据的合法性后，缓存数据就可以使用，否则从原始地址加载。
             */

            // reloadIgnoringLocalAndRemoteCacheData 和 reloadRevalidatingCacheData没有实现

            let cachePolicy: URLRequest.CachePolicy = isReachable ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad

            var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 1)

            /*
             * public 所有内容都将被缓存
             * private 内容只缓存到私有缓存中
             * no-cache 所有内容都不会被缓存
             * no-store 所有内容都不会被缓存到缓存或Internet文件中，
             */

            request.addValue("private", forHTTPHeaderField: "Cache-Control") // 这个头必须由服务器端指定以开启客户端的 HTTP 缓存功能。这个头的值可能包含 max-age（缓存多久），是公共 public 还是私有 private，或者不缓存 no-cache 等信息

            let task = session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    if let json = JSON(data).dictionaryValue["段子"] {
                        let data = json.arrayValue.compactMap { $0.dictionaryValue["digest"]?.stringValue }
                        if self.isLoadingMore {
                            self.contents.append(contentsOf: data)
                        } else {
                            self.contents.insert(contentsOf: data, at: 0)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = Constants.backgroundColor
        cell.textLabel?.font = font
        cell.textLabel?.text = contents[indexPath.section]
        cell.textLabel?.textColor = Constants.textColor
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func openURL(type: String) {
        let paste = UIPasteboard.general
        paste.string = selectedText
        let urlStr = type.replacingOccurrences(of: "()", with: "") + "://"
        UIApplication.shared.openURL(URL(string: urlStr)!)
    }

    @objc func mqq() {
        openURL(type: #function)
    }

    @objc func wechat() {
        openURL(type: #function)
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == contents.count else {
            let customView = UIView()
            customView.backgroundColor = UIColor.white
            return customView
        }
        return super.tableView(tableView, viewForFooterInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    var selectedText: String?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            becomeFirstResponder()  // 这里先注释
            /*
                The first responder is designated to receive events first. Typically, the first responder is a view object. An object becomes the first responder by doing two things:
             
                1. Overriding the canBecomeFirstResponder method to return YES.
                2. Receiving a becomeFirstResponder message. If necessary, an object can send itself this message.
             */
            let qqItem = UIMenuItem(title: "QQ", action: #selector(mqq))
            let wechatItem = UIMenuItem(title: "wechat", action: #selector(wechat))
            let menuController = UIMenuController.shared
            menuController.menuItems = [qqItem, wechatItem]
            menuController.setTargetRect(cell.frame, in: cell.superview!)
            menuController.setMenuVisible(true, animated: true)
            selectedText = cell.textLabel?.text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
