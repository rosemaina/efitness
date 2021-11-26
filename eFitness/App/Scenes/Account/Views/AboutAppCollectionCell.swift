//
//  AboutAppCollectionCell.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import UIKit

class AboutAppCollectionCell: UITableViewCell {
    
    // MARK: - Properties
    var contentHolder = UIView.shadowedCard(Colors.backgroundGreen)
    var aboutImage = UIImageView.createImageView(imageName: nil, imageTint: nil, edgeSize: nil, contentMode: .scaleToFill)
    var titleLabel = UILabel.createLabel(title: "", textColor: Colors.darkGreen, font: Fonts.montserratLight(13), alignment: .center, lineBreakMode: .byWordWrapping)

    // MARK: - Initialize Favorites custom view cell and set constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    // MARK: - Setup table view cell properties
    private func setup() {
        addSubview(contentHolder)
        [aboutImage, titleLabel].forEach { contentHolder.addSubview($0) }
        
        selectionStyle = .none
        backgroundColor = Colors.backgroundGreen
        titleLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            contentHolder.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            contentHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            contentHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            contentHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

            aboutImage.topAnchor.constraint(equalTo: contentHolder.topAnchor, constant: 15),
            aboutImage.centerXAnchor.constraint(equalTo: contentHolder.centerXAnchor),
            aboutImage.widthAnchor.constraint(equalToConstant: 150),
            aboutImage.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: aboutImage.bottomAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: contentHolder.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentHolder.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentHolder.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Create initialiser that will be called if an instance of our custom view cell is used
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
