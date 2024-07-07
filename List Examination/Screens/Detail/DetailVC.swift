//
//  DetailVC.swift
//  List Examination
//
//  Created by Farras on 06/07/24.
//

import UIKit

class DetailVC: UIViewController {
    
    // MARK: - Data variables
    var casts = [Cast]()
    var movieId: Int?
    var data: MovieDetail?
    
    // MARK: UI Elements
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let bannerImg: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let backBtn: UIButton = {
        let v = UIButton()
        v.setImage(#imageLiteral(resourceName: "Back Arrow"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    @objc private func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-SemiBold", size: 20.0)!
        label.text = "Movie Title Here 1"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "1 h 29 m"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    let hdView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderWidth = 1.0
        v.layer.borderColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1).cgColor
        v.layer.cornerRadius = 6.0
        return v
    }()
    
    let hdLabel: UILabel = {
        let label = UILabel()
        label.text = "HD"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Drama, Asia, Comedy, Series"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam, purus sit amet luctus venenatis, lectus magna fringilla urna, porttitor rhoncus dolor purus non enim praesent elementum facilisis leo, vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis enim lobortis scelerisque fermentum dui faucibus in ornare quam viverra orci sagittis eu volutpat odio facilisis mauris sit amet massa vitae tortor condimentum lacinia quis vel eros donec ac odio tempor orci dapibus ultrices in iaculis nunc sed augue lacus, viverra vitae congue eu, consequat ac felis donec et odio pellentesque diam volutpat commodo sed egestas egestas fringilla phasellus faucibus"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Regular", size: 12.0)
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    let castLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-SemiBold", size: 14.0)
        label.textColor = .black
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(80, 130)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        hdView.addSubview(hdLabel)
        NSLayoutConstraint.activate([
            hdLabel.leadingAnchor.constraint(equalTo: hdView.leadingAnchor, constant: 4),
            hdLabel.topAnchor.constraint(equalTo: hdView.topAnchor, constant: 2),
            hdLabel.trailingAnchor.constraint(equalTo: hdView.trailingAnchor, constant: -4),
            hdLabel.bottomAnchor.constraint(equalTo: hdView.bottomAnchor, constant: -2)
        ])
        
        let hdStack = UIStackView(arrangedSubviews: [yearLabel, hdView])
        hdStack.axis = .horizontal
        hdStack.spacing = 12
        hdStack.alignment = .center
        hdStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bannerImg)
        backBtn.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        contentView.addSubview(backBtn)
        NSLayoutConstraint.activate([
            bannerImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImg.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            bannerImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImg.heightAnchor.constraint(equalTo: bannerImg.widthAnchor),
            
            backBtn.heightAnchor.constraint(equalToConstant: 24),
            backBtn.widthAnchor.constraint(equalToConstant: 24),
            backBtn.leadingAnchor.constraint(equalTo: bannerImg.leadingAnchor, constant: 16),
            backBtn.topAnchor.constraint(equalTo: bannerImg.topAnchor, constant: 20),
        ])
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, hdStack, genreLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 4
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelStack)
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: bannerImg.leadingAnchor, constant: 16),
            labelStack.bottomAnchor.constraint(equalTo: bannerImg.bottomAnchor, constant: -16),
            labelStack.trailingAnchor.constraint(greaterThanOrEqualTo: bannerImg.trailingAnchor),
        ])
        
        contentView.addSubview(descLabel)
        NSLayoutConstraint.activate([
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descLabel.topAnchor.constraint(equalTo: bannerImg.bottomAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        contentView.addSubview(castLabel)
        NSLayoutConstraint.activate([
            castLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            castLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 24),
            castLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        setupCollectionView()
        refreshView()
        setupData()
    }
    
    private func setupData() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            // TODO: Zip using combine
            Task {
                await self.fetchData()
                await self.fetchCast()
            }
        }
    }
    
    private func fetchData() async {
        guard let movieId else { return }
        let url = URL(string: "https://api.themoviedb.org/3/movie/"+String(movieId))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlM2Q1YWIzNjdlYTY3ZGY1OTg1ZjYyYTJkMjExOGQyZCIsIm5iZiI6MTcyMDM0NTc4Mi41NzA5NDEsInN1YiI6IjVhZDAwMzI4OTI1MTQxN2I2MDAwNDYxMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jeuj_kdlpGm4qVPaCYstpiY3yFpBkshjNiHCU5VuqhY"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            let movieDetail = try decoder.decode(MovieDetail.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.data = movieDetail
                self.refreshView()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    private func refreshView() {
        titleLabel.text = data?.title ?? ""
        
        if let releaseDate = data?.releaseDate {
            let components = releaseDate.components(separatedBy: "-")
            let year = components.first ?? ""
            yearLabel.text = year
        }
        
        if let genres = data?.genres {
            let genreNames = genres.compactMap { $0.name }.joined(separator: ", ")
            genreLabel.text = genreNames
        }
        
        descLabel.text = data?.overview ?? ""
        updateBannerImg()
    }
    
    private func updateBannerImg() {
        Task {
            do {
                guard let backdropPath = data?.backdropPath else {
                    throw NSError(domain: "BackdropPathError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Backdrop path is nil"])
                }
                
                let urlString = "https://image.tmdb.org/t/p/w500" + backdropPath
                guard let url = URL(string: urlString) else {
                    throw NSError(domain: "URLCreationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                }
                
                let image = try await loadImageAsync(url: url)
                DispatchQueue.main.async {
                    self.bannerImg.image = image
                }
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    func loadImageAsync(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
        }
        return image
    }
    
    private func fetchCast() async {
        guard let movieId else { return }
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(String(movieId))/credits")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlM2Q1YWIzNjdlYTY3ZGY1OTg1ZjYyYTJkMjExOGQyZCIsIm5iZiI6MTcyMDM0NTc4Mi41NzA5NDEsInN1YiI6IjVhZDAwMzI4OTI1MTQxN2I2MDAwNDYxMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jeuj_kdlpGm4qVPaCYstpiY3yFpBkshjNiHCU5VuqhY"
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            let castResult = try decoder.decode(CastResult.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.casts = castResult.cast ?? []
                self.refreshCast()
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    private func refreshCast() {
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 8.0),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.identifier, for: indexPath) as! CastCell
        
        let cast = casts[indexPath.row]
        let castName = cast.name ?? ""
        cell.configure(with: castName)
        
        return cell
    }
}
