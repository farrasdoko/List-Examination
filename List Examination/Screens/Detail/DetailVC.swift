//
//  DetailVC.swift
//  List Examination
//
//  Created by Farras on 06/07/24.
//

import UIKit

class DetailVC: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var bannerImg: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var backBtn: UIButton = {
        let v = UIButton()
        v.setImage(#imageLiteral(resourceName: "Back Arrow"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
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
    }
}
