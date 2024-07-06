//
//  CastCell.swift
//  List Examination
//
//  Created by Farras on 07/07/24.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    let castBanner: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        v.layer.cornerRadius = 40
        v.clipsToBounds = true
        return v
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(castBanner)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            castBanner.heightAnchor.constraint(equalToConstant: 80),
            castBanner.widthAnchor.constraint(equalToConstant: 80),
            castBanner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            castBanner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            castBanner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: castBanner.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

    func configure(with name: String) {
        titleLabel.text = name
    }
}
