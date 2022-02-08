import UIKit

class ProductAddingView: UIStackView {
    
    private let addImagebutton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.backgroundColor = .systemGray
        return button
    }()
    
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
        textView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = "aaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjcaaaaaaaaaaaaaaaaaaaaaaaaaaaasdlaksdjalksdjqlijraihlzjxnclzkxjc"
        return textView
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
        
        self.addArrangedSubview(addImagebutton)
        self.addArrangedSubview(nameField)
        self.addArrangedSubview(priceStack)
        self.addArrangedSubview(discountField)
        self.addArrangedSubview(stockField)
        self.addArrangedSubview(descriptionField)
        
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 8
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
