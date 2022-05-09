//
//  DisplayView.swift
//  CoreImageStudy
//
//  Created by 黄伯驹 on 2019/2/14.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class DisplayView: UIView {
    
    public var originalImage: UIImage? {
        didSet {
            originalImageView.image = originalImage
        }
    }
    
    public var processedImage: UIImage? {
        didSet {
            processedImageView.image = processedImage
        }
    }

    private lazy var originalImageView: ContentView = {
        let imageView = ContentView()
        imageView.backgroundColor = UIColor(hex: 0xFF6369)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.text = "Original"
        return imageView
    }()
    
    private lazy var processedImageView: ContentView = {
        let imageView = ContentView()
        imageView.backgroundColor = UIColor(hex: 0xFF6369)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.text = "Processed"
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [originalImageView, processedImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ContentView: UIView {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.boldSystemFont(ofSize: 48)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        textLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: NSLayoutConstraint.Axis.vertical)
        return textLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(textLabel)
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
