//
//  ManageAccountCell.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import UIKit

class ManageAccountCell: UITableViewCell {
    
    // MARK: - Properties
    var contentHolder = UIView.shadowedCard(Colors.backgroundGreen)
    var titleLabel = UILabel.createLabel(title: "", textColor: Colors.darkGreen, font: Fonts.montserratRegular(13))

    // MARK: - Initialize Favorites custom view cell and set constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    // MARK: - Setup table view cell properties
    private func setup() {
        addSubview(contentHolder)
        contentHolder.addSubview(titleLabel)
        contentHolder.bringSubviewToFront(titleLabel)

        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = Colors.backgroundGreen
        
        NSLayoutConstraint.activate([
            contentHolder.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            contentHolder.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            contentHolder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            contentHolder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),

            titleLabel.topAnchor.constraint(equalTo: contentHolder.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentHolder.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentHolder.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentHolder.trailingAnchor, constant: -10)
        ])
    }

    // MARK: - Create initialiser that will be called if an instance of our custom view cell is used
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
