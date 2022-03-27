//
//  CategoryCollectionViewCell.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 27/1/22.

import UIKit
import SnapKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemBlue,
        .systemPink,
        .systemPurple,
        .systemTeal,
        .systemGray,
        .systemGreen,
        .systemOrange,
        .systemIndigo,
        .systemYellow
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().inset(10)
            maker.width.equalTo(contentView.width-20)
            maker.height.equalTo(30)
        }
        
        imageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(5)
            maker.trailing.equalToSuperview().inset(5)
            maker.width.equalTo(contentView.width/2)
            maker.height.equalTo(contentView.height/2)
        }
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel){
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
