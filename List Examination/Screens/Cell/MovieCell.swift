//
//  MovieCell.swift
//  List Examination
//
//  Created by Farras on 06/07/24.
//

import UIKit

class MovieCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    let movieBanner: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        return v
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 16.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()

    let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 16.0)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(movieBanner)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(genreLabel)

        NSLayoutConstraint.activate([
            movieBanner.heightAnchor.constraint(equalToConstant: 100),
            movieBanner.widthAnchor.constraint(equalToConstant: 100),
            movieBanner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            movieBanner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            movieBanner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: movieBanner.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),

            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 2),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            genreLabel.bottomAnchor.constraint(equalTo: movieBanner.bottomAnchor, constant: 0),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])
    }

    func configure(with title: String, year: String, genre: String) {
        titleLabel.text = title
        yearLabel.text = year
        genreLabel.text = genre
    }
}
