import UIKit

class ProductGridCell: UICollectionViewCell {
    let productName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let productThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4).isActive = true
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

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setCellLayout() {
        contentView.addSubview(productStackView)
        productStackView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 2
        
        NSLayoutConstraint.activate([
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configCell(with product: Product) {
        setThumbnailImage(with: product.thumbnail)
        productName.text = product.name
        productName.font = UIFont.preferredFont(forTextStyle: .title1)
        setPriceLabel(product.currency.rawValue, Int(product.price), Int(product.discountedPrice))
        setStockLabel(with: product.stock)
    }
    
    private func setThumbnailImage(with thumbnailString: String) {
        guard let thumbnailURL = URL(string: thumbnailString) else { return }
        var thumbnailData = Data()
        do {
            thumbnailData = try Data(contentsOf: thumbnailURL)
        } catch {
            
        }
        productThumbnail.image = UIImage(data: thumbnailData)
    }
    
    private func setPriceLabel(_ currency: String, _ price: Int, _ discountedPrice: Int) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else { return }
        guard let formatteddiscountedPrice = numberFormatter.string(from: NSNumber(value: price-discountedPrice)) else { return }
        
        productPrice.textColor = .systemGray
        productPrice.numberOfLines = 0
        
        if discountedPrice == 0 {
            productPrice.text = "\(currency) \(formattedPrice)"
            productPrice.font = UIFont.preferredFont(forTextStyle: .body)
            
        } else {
            let fullText = "\(currency) \(formattedPrice)\n\(currency) \(formatteddiscountedPrice)"
            let oldPrice = (fullText as NSString).range(of: "\(currency) \(formattedPrice)")
            let newPrice = (fullText as NSString).range(of: "\n\(currency) \(formatteddiscountedPrice)")
            let attributedString = NSMutableAttributedString(string: fullText)
            
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: oldPrice)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: oldPrice)
            attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: newPrice)
            attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: oldPrice)
            productPrice.attributedText = attributedString
        }
    }
    
    private func setStockLabel(with stock: Int) {
        productRemainedStock.text = stock == 0 ? "품절" : "잔여수량: \(stock)"
        productRemainedStock.font = UIFont.preferredFont(forTextStyle: .body)
        productRemainedStock.textColor = stock == 0 ? .orange : .systemGray
    }

}
