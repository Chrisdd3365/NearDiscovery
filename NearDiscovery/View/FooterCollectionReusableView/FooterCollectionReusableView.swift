//
//  FooterCollectionReusableView.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 24/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

//Setup the footerView to display label into CollectionView when it's empty
class FooterCollectionReusableView: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel()
        label.text = "Hit the 'Marked Location' Button to add the location into the list!".localized()
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FooterCollectionReusableView {
    private func setConstraints() {
        addSubview(label)
        label.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
