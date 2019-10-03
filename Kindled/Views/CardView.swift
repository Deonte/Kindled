//
//  CardView.swift
//  Kindled
//
//  Created by Deonte on 9/26/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    // Configurations
    fileprivate let threshold: CGFloat = 80
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    var cardViewModel: CardViewModel! {
        didSet {
            
            let imageName = cardViewModel.imageNames.first ?? ""
            
            imageView.image = UIImage(named: imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            if cardViewModel.imageNames.count > 1 {
                (0..<cardViewModel.imageNames.count).forEach { (_) in
                    let barView = UIView()
                    barView.layer.cornerRadius = 2
                    barView.backgroundColor = barDeselectedColor
                    barsStackView.addArrangedSubview(barView)
                }
                barsStackView.arrangedSubviews.first?.backgroundColor = .white
                setupImageIndexObserver()
            }
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [unowned self](index, image) in
            print("Changing photo from view model")
            self.imageView.image = image
            
            self.barsStackView.arrangedSubviews.forEach { (v) in
                v.backgroundColor = self.barDeselectedColor
            }
            self.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate let informationLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let barsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    fileprivate let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.5, 1.1]
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupImageView()
        setupBarsStackView()
        setupGreadientLayer()
        setupInformationLabel()
        setupGestures()
    }
    
    fileprivate func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func setupImageView() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    fileprivate func setupInformationLabel() {
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    fileprivate func setupGreadientLayer() {
        layer.addSublayer(gradientLayer)
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        
        let canTap = cardViewModel.imageNames.count > 1
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width/2 ? true : false
        
        if canTap {
            if shouldAdvanceNextPhoto {
                cardViewModel.advanceToNextPhoto()
            } else {
                cardViewModel.goToPreviousPhoto()
            }
        } else {
            print("User only has one picture Bro")
        }
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                let offScreenTransform = self.transform.translatedBy(x: 1000 * translationDirection, y: 0)
                self.transform = offScreenTransform
                //self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
