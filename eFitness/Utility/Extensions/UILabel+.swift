//
//  UILabel+.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import UIKit

extension UILabel {
    
    static func createLabel(title: String,
                            textColor: UIColor = .black,
                            font: UIFont = Fonts.montserratSemiBold(12),
                            alignment: NSTextAlignment = .left,
                            lineBreakMode: NSLineBreakMode = .byWordWrapping) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = alignment
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

extension UICollectionView {
    static func createImageCarousel(view: UIView) -> UICollectionView {
        let collectionView = createCollectionView(parent: view, scrollDirection: .horizontal)
        collectionView.isPagingEnabled = true
        collectionView.autoresizesSubviews = false
        
        return collectionView
    }
    
    static func createCollectionView(parent: UIView, scrollDirection: UICollectionView.ScrollDirection = .vertical) -> UICollectionView {
        // Create an instance of UICollectionViewFlowLayout since you cant
        // Initialize UICollectionView without a layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        
        let collectionView = UICollectionView(frame: parent.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.backgroundGreen
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
}

extension UIImageView {
    
    class func createImageView(imageName: String? = nil, imageTint: UIColor? = nil, edgeSize: CGFloat? = nil, contentMode: UIView.ContentMode? = nil) -> UIImageView {
        let imageView = UIImageView()
        if let imageName = imageName {
            imageView.image = imageTint == nil ? UIImage(named: imageName)
                : UIImage(named: imageName)?.ignoringColor
        }
        if let imageTint = imageTint { imageView.tintColor = imageTint }
        if let contentMode = contentMode { imageView.contentMode = contentMode }
        addConstraints(to: imageView, edgeSize: edgeSize)
        return imageView
    }
    
    private class func addConstraints(to imageView: UIImageView, edgeSize: CGFloat? = nil) {
        if let edgeSize = edgeSize {
            imageView.widthAnchor.constraint(equalToConstant: edgeSize).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: edgeSize).isActive = true
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIImage {
    
    func resize(edgeSize: CGFloat) -> UIImage? {
        let newSize = CGSize(width: edgeSize, height: edgeSize)
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }.withRenderingMode(self.renderingMode)
    }
    
    var ignoringColor: UIImage? {
        self.withRenderingMode(.alwaysTemplate)
    }
}
