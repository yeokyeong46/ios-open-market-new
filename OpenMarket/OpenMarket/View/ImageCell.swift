import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "imageCell"
    
    let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(imageURLString: String){
        guard let imageURL = URL(string: imageURLString) else { return }
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: imageURL)
        } catch {
            
        }
        imageView.image = UIImage(data: imageData)
    }
    
    func setImage(addedImage: UIImage) {
        imageView.image = addedImage
    }
    
    func setPlusImage() {
        imageView.image = UIImage(named: "plus")
    }
    
    private func addViews(){
        addSubview(imageView)
    }
    
    private func setConstraints(){
        labelConstraints()
    }
    
    private func labelConstraints(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
