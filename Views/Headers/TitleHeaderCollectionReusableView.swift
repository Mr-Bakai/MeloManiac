//
//  TitleHeaderCollectionReusableView.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 23/1/22.
//

import UIKit
import SnapKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.top.equalToSuperview()
            maker.height.equalTo(height)
            maker.width.equalTo(width-20)
        }
    }
    
    func configure(with title: String){
        label.text = title
    }
}
