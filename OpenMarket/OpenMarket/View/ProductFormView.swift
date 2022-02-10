import UIKit

class ProductFormView: UIStackView {
    
    private let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let priceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
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
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let stockField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let descriptionField: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = "상품설명"
        return textView
    }()
    
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameField.delegate = self
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

        self.addArrangedSubview(textStack)
    }
    
    func setData(with product: ProductDetail) {
        nameField.text = product.name
        priceField.text = String(Int(product.price))
        currencySegment.selectedSegmentIndex = product.currency.rawValue == "KRW" ? 0 : 1
        discountField.text = String(Int(product.discountedPrice))
        stockField.text = String(Int(product.stock))
        descriptionField.text = product.description
    }
    
    func getFormData() -> Dictionary<String, Any> {
        return [
            "name" : nameField.text,
            "descriptions" : descriptionField.text,
            "price" : Int(priceField.text!),
            "currency" : currencySegment.selectedSegmentIndex.description,
             "secret": myPassword,
            "discounted_price": (discountField.text != nil ? Int(discountField.text!) : 0),
            "stock": (stockField.text != nil ? Int(stockField.text!) : 0)
        ]
    }
}

extension ProductFormView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
