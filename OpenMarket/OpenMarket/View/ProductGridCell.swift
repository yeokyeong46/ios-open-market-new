//
//  ProductGridCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import UIKit

class ProductGridCell: UICollectionViewCell {
    let productName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let productThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let productRemainedStock: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productThumbnail, productName, productPrice, productRemainedStock])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func layout() {
        contentView.addSubview(productStackView)
        productStackView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configCell(with product: Product) {
        let thumbnailString = product.thumbnail
        guard let thumbnailURL = URL(string: thumbnailString) else { return }
        var thumbnailData = Data()
        do {
            thumbnailData = try Data(contentsOf: thumbnailURL)
        } catch {
            
        }
        productThumbnail.image = UIImage(data: thumbnailData)
        productName.text = product.name
        productName.font = UIFont.preferredFont(forTextStyle: .title1)
        
        
        
        let currency = product.currency.rawValue
        let price = product.price
        let discountedPrice = product.discountedPrice
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else { return }
        guard let formatteddiscountedPrice = numberFormatter.string(from: NSNumber(value: discountedPrice)) else { return }
        
        productPrice.textColor = .systemGray
        productPrice.numberOfLines = 0
        
        if discountedPrice == 0 {
            productPrice.text = "\(currency) \(formattedPrice)"
            productPrice.font = UIFont.preferredFont(forTextStyle: .body)
            
        } else {
            let fullText = "\(currency) \(formattedPrice)\n\(currency) \(formatteddiscountedPrice)"
            let oldPrice = (fullText as NSString).range(of: "\(currency) \(formattedPrice)")
            let newPrice = (fullText as NSString).range(of: "\(currency) \(formatteddiscountedPrice)")
            let attributedString = NSMutableAttributedString(string: fullText)
            
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: oldPrice)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: oldPrice)
            attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: newPrice)
            attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: oldPrice)
            productPrice.attributedText = attributedString
        }
        
        productRemainedStock.text = product.stock == 0 ? "품절" : "잔여수량: \(product.stock)"
        
        productRemainedStock.font = UIFont.preferredFont(forTextStyle: .body)
        productRemainedStock.textColor = product.stock == 0 ? .orange : .systemGray
    }

}
