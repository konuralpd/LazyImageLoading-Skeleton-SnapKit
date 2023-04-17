//
//  HomeViewController.swift
//  LazyImageLoading+Skeleton+SnapKit
//
//  Created by Mac on 17.04.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    //Mark: UI Elements
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.delegate = self
        vc.showsVerticalScrollIndicator = false
        vc.dataSource = self
        vc.alwaysBounceVertical = false
        vc.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return vc
    }()

    //Mark: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        
    }
    

    //Mark: Functions
    private func makeUI() {
        title = "Images"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        } //To change large title text Color
        makeCollectionView()
    }
    
    private func makeCollectionView() {
        view.addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

//Mark: CollectionView Ext+

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = imageData[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell()}
        if let url = URL(string: image) {
            cell.cellImage.loadImage(with: url)
        }
        return cell
    }
    
    

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageCell = cell as? ImageCollectionViewCell, !imageCell.isAnimating {
            imageCell.alpha = 0
            imageCell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
               UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
                   imageCell.alpha = 1
                   imageCell.transform = CGAffineTransform.identity
               }, completion: nil)
            imageCell.isAnimating = true
           }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let collectionViewSize = collectionView.frame.size.width - padding * 2
        let itemWidth = (collectionViewSize - 8) / 3
        return CGSize(width: itemWidth, height: itemWidth * 1.5)
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 12
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 8
     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    }
}
