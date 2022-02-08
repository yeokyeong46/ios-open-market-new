import UIKit

class ProductFormViewController: UIViewController {
    private var product: Product?
    private let productAddingForm = ProductFormView()
    private let scrollView = UIScrollView()

    init(prod: Product?) {
        product = prod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigationItems()
        setFormUI()
        if product != nil {
            navigationItem.title = "상품수정"
            setProductData()
        }
    }
    
    func setProductData() {
        productAddingForm.setData(with: product!)
    }
    
    
    func setFormUI() {
        view.addSubview(scrollView)
        arrangeConstraint(view: scrollView, guide: view.safeAreaLayoutGuide)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(container)
        arrangeConstraint(view: container, guide: scrollView.contentLayoutGuide)
        container.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        container.addSubview(productAddingForm)
        
        productAddingForm.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        productAddingForm.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        productAddingForm.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        productAddingForm.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
    }
    
    func setNavigationItems() {
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addingAction))
    }
    
    @objc
    func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func addingAction() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension UIViewController {
    func arrangeConstraint(view: UIView, guide: UILayoutGuide) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }
}
