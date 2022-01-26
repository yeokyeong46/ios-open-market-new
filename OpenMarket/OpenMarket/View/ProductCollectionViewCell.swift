import UIKit

// Declare a custom key for a custom `item` property.
fileprivate extension UIConfigurationStateCustomKey {
    static let product = UIConfigurationStateCustomKey("product")
}

// Declare an extension on the cell state struct to provide a typed property for this custom state.
extension UICellConfigurationState {
    var product: Product? {
        set { self[.product] = newValue }
        get { return self[.product] as? Product }
    }
}

// This list cell subclass is an abstract class with a property that holds the item the cell is displaying,
// which is added to the cell's configuration state for subclasses to use when updating their configuration.
class ProductListCell: UICollectionViewListCell {
    private var product: Product?
    private func defaultProductConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private let productStockLabel = UILabel()
    private var productStockLabelContraints: (leading: NSLayoutConstraint, trailing: NSLayoutConstraint)?
    
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
                          trailing: productStockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        NSLayoutConstraint.activate([
            productListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productListContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contraints.leading,
            contraints.trailing
        ])
        
        productStockLabelContraints = contraints
        
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewIfNeeded()
        
        var content = defaultProductConfiguration().updated(for: state)
        
        guard let thumbnailString = state.product?.thumbnail else { return }
        guard let thumbnailURL = URL(string: thumbnailString) else { return }
        var thumbnailData = Data()
        do {
            thumbnailData = try Data(contentsOf: thumbnailURL)
        } catch {
            
        }
        content.image = UIImage(data: thumbnailData)
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = state.product?.name
        content.secondaryText = "\(state.product?.currency.rawValue) \(state.product?.price)"
        
        productListContentView.configuration = content
        
        productStockLabel.text = "잔여수량: \(state.product?.stock)"
    }
}
