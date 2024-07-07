//
//  CastCell.swift
//  List Examination
//
//  Created by Farras on 07/07/24.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    // MARK: Other property
    var imageURL: URL?
    var task: URLSessionDataTask?
    
    // MARK: - UI Elements
    
    let castBanner: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        v.layer.cornerRadius = 40
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
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

    func configure(with name: String, imageUrl: String) {
        titleLabel.text = name
        castBanner.image = nil
        
        guard let imageURL = URL(string: imageUrl) else { return }
        self.imageURL = imageURL
        if let cachedImage = ImageCache.shared.image(for: imageURL) {
            castBanner.image = cachedImage
        } else {
            task = loadImage(from: imageURL) { [weak self] image in
                guard let self = self, let image = image else { return }
                DispatchQueue.main.async {
                    if self.imageURL == imageURL {
                        self.castBanner.image = image
                    }
                }
                ImageCache.shared.saveImage(image, for: imageURL)
            }
            task?.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        task?.cancel()
        task = nil
        
        castBanner.image = nil
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        return URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
