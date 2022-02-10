import UIKit

class ProductDetailViewController: UIViewController, UICollectionViewDelegate {
    private let product: ProductDetail
    
    private let scrollView = UIScrollView()
    private let container = UIView()
    private let prodcutDetailView = ProductDetailView()
    
    private lazy var imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.width - 32), collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    init (product: ProductDetail) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        prodcutDetailView.setData(with: product)
        setNavigationItems()
        setUI()
    }
    
    private func setNavigationItems() {
        navigationItem.title = product.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActions))
    }
    
    private func setUI() {
        view.addSubview(scrollView)
        arrangeConstraint(view: scrollView, guide: view.safeAreaLayoutGuide)
        scrollView.addSubview(container)
        arrangeConstraint(view: container, guide: scrollView.contentLayoutGuide)
        container.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        setImageCollectionUI()
//        setProductDetailUI()
    }
    
    private func setImageCollectionUI() {
        container.addSubview(imageCollectionView)
        
        imageCollectionView.backgroundColor = .red
        
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: container.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            imageCollectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            imageCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width - 32)
        ])
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    private func setProductDetailUI() {
        container.addSubview(prodcutDetailView)
        NSLayoutConstraint.activate([
            prodcutDetailView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            prodcutDetailView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            prodcutDetailView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            prodcutDetailView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
    }
}

extension ProductDetailViewController {
    @objc
    private func showActions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let share = UIAlertAction(title: "수정", style: .default) {
            (action) in
            self.editAction()
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) {
            (action) in
            self.deleteAction()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(share)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func editAction() {
        let productEditingView = ProductFormViewController(prod: product)
        productEditingView.delegate = SceneDelegate.rootViewController as? ProductsViewController
        self.navigationController?.pushViewController(productEditingView, animated: true)
    }
    
    private func deleteAction() {
        print("delete")
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.setImage(imageURLString: product.images[indexPath.row].url)
        return cell
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 50, height: view.frame.width - 50)
    }
}
