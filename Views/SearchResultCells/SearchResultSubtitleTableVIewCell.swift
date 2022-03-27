//
//  SearchResultSubtitleTableVIewCell.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 6/3/22.
//

import UIKit
import SDWebImage
import SnapKit

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
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
        contentView.addSubview(subtitleLabel)
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
            maker.height.equalTo(contentView.height/3)
            maker.width.equalToSuperview()
            maker.top.equalToSuperview().offset(5)
        }
        
        subtitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(iconImageView.snp.trailing).offset(10)
            maker.height.equalTo(contentView.height/3)
            maker.width.equalToSuperview()
            maker.bottom.equalToSuperview().inset(5)
        }   
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        subtitleLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel){
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL,
                                  placeholderImage: UIImage(systemName: "photo"), completed: nil)
    }
}
