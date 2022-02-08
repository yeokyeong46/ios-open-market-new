import UIKit

class ProductFormView: UIStackView {
//
//    let imageScrollView = UIScrollView()
//
//    private let imageStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 8
//        return stack
//    }()
//
    private let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let priceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let currencySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["KRW","USD"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let priceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private let discountField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let stockField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let descriptionField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = " 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지 상품설명 1000자 까지"
        return textView
    }()
    
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
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
        
        priceStack.addArrangedSubview(priceField)
        priceStack.addArrangedSubview(currencySegment)
        
        textStack.addArrangedSubview(nameField)
        textStack.addArrangedSubview(priceStack)
        textStack.addArrangedSubview(discountField)
        textStack.addArrangedSubview(stockField)
        textStack.addArrangedSubview(descriptionField)
        
//        imageScrollView.addSubview(imageStack)
//        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
//        imageScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        imageScrollView.bottomAnchor.constraint(equalTo: textStack.topAnchor).isActive = true
//
//        self.addArrangedSubview(imageScrollView)
        self.addArrangedSubview(textStack)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 8
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setData(with product: ProductDetail) {
        nameField.text = product.name
        priceField.text = String(product.price)
        currencySegment.selectedSegmentIndex = product.currency.rawValue == "KRW" ? 0 : 1
        discountField.text = String(product.discountedPrice)
        stockField.text = String(product.stock)
        descriptionField.text = product.description
        
//        for image in product.images {
//            let imageView = UIImageView()
//
//            guard let imageURL = URL(string: image.url) else { return }
//            var imageData = Data()
//            do {
//                imageData = try Data(contentsOf: imageURL)
//            } catch {
//
//            }
//            imageView.image = UIImage(data: imageData)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.contentMode = .scaleAspectFit
//            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3).isActive = true
//            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3).isActive = true
//
//            imageStack.addArrangedSubview(imageView)
//        }
    }
}
