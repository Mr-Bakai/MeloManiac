//
//  SearchResultDefaultTableViewCell.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 5/3/22.
//

import UIKit
import SDWebImage
import SnapKit

class SearchResultDefaultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder:NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        
        iconImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(imageSize)
            maker.leading.equalToSuperview().offset(5)
            maker.top.equalToSuperview().offset(5)
            maker.bottom.equalToSuperview().inset(5)
        }
        
        label.snp.makeConstraints { maker in
            maker.leading.equalTo(iconImageView.snp.trailing).offset(10)
            maker.height.equalTo(contentView.height)
            maker.width.equalToSuperview()
            maker.top.equalTo(iconImageView.snp.top)
            maker.bottom.equalTo(iconImageView.snp.bottom)
        }
        
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        iconImageView.image = nil
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel){
        label.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
}
