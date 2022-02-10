import UIKit

class ProductDetailView: UIStackView {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .red
//        label.textColor.setStroke()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameAndStockStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 8
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let priceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 4
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingStacks()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingStacks() {
        
        nameAndStockStack.addArrangedSubview(nameLabel)
        nameAndStockStack.addArrangedSubview(stockLabel)
        
        priceStack.addArrangedSubview(priceLabel)
        priceStack.addArrangedSubview(discountedPriceLabel)
        
        detailStack.addArrangedSubview(nameAndStockStack)
        detailStack.addArrangedSubview(priceStack)
        detailStack.addArrangedSubview(descriptionLabel)
        
        self.addArrangedSubview(detailStack)
    }
    
    func setData(with product: ProductDetail) {
        nameLabel.text = product.name
        stockLabel.text = "남은수량: \(product.stock)"
        priceLabel.text = String(product.price)
        discountedPriceLabel.text = String(product.discountedPrice)
        descriptionLabel.text = product.description
    }

}
