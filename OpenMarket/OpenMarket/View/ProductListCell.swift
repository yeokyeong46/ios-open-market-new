import UIKit

fileprivate extension UIConfigurationStateCustomKey {
    static let product = UIConfigurationStateCustomKey("product")
}

extension UICellConfigurationState {
    var product: Product? {
        set { self[.product] = newValue }
        get { return self[.product] as? Product }
    }
}

class ProductListCell: UICollectionViewListCell {
    private var product: Product?
    private func defaultProductConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private let productStockLabel = UILabel()
    private var productStockLabelContraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint, centerY: NSLayoutConstraint)?
    
    private lazy var productListContentView = UIListContentView(configuration: defaultProductConfiguration())
    
    func update(with newProduct: Product) {
        guard product != newProduct else { return }
        product = newProduct
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.product = self.product
        return state
    }
    
    func setupViewIfNeeded() {
        guard productStockLabelContraints == nil else {
            return
        }
        
        [productListContentView, productStockLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let contraints = (leading: productStockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: productListContentView.trailingAnchor),
                          trailing: productStockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                          centerY: productStockLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
        
        NSLayoutConstraint.activate([
            productListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productListContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contraints.leading,
            contraints.trailing,
            contraints.centerY
        ])
        
        productStockLabelContraints = contraints
        
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewIfNeeded()
        
        var content = defaultProductConfiguration().updated(for: state)
        content.axesPreservingSuperviewLayoutMargins = []
        
        guard let thumbnailString = state.product?.thumbnail else { return }
        guard let thumbnailURL = URL(string: thumbnailString) else { return }
        var thumbnailData = Data()
        do {
            thumbnailData = try Data(contentsOf: thumbnailURL)
        } catch {
            
        }
        content.image = UIImage(data: thumbnailData)
        content.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.height * 0.09, height: UIScreen.main.bounds.height * 0.09)
        content.text = state.product?.name
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .title1)
        
        guard let currency = state.product?.currency.rawValue,
              let price = state.product?.price,
              let discountedPrice = state.product?.discountedPrice
        else { return }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else { return }
        guard let formatteddiscountedPrice = numberFormatter.string(from: NSNumber(value: discountedPrice)) else { return }
        
        content.secondaryTextProperties.color = .systemGray
        content.secondaryTextProperties.numberOfLines = 0
        
        if discountedPrice == 0 {
            content.secondaryText = "\(currency) \(formattedPrice)"
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .body)
            
        } else {
            let fullText = "\(currency) \(formattedPrice) \(currency) \(formatteddiscountedPrice)"
            let oldPrice = (fullText as NSString).range(of: "\(currency) \(formattedPrice)")
            let newPrice = (fullText as NSString).range(of: "\(currency) \(formatteddiscountedPrice)")
            let attributedString = NSMutableAttributedString(string: fullText)
            
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: oldPrice)
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: oldPrice)
            attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: newPrice)
            attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: oldPrice)
            content.secondaryAttributedText = attributedString
        }

        productListContentView.configuration = content
        
        guard let stock = state.product?.stock else { return }
        productStockLabel.text = stock == 0 ? "품절" : "잔여수량: \(stock)"
        
        productStockLabel.font = UIFont.preferredFont(forTextStyle: .body)
        productStockLabel.textColor = stock == 0 ? .orange : .systemGray
    }
}
