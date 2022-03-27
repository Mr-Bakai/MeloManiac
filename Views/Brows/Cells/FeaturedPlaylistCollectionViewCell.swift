//
//  FeaturedCollectionViewCell.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 21/1/22.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        image.image = UIImage(systemName: "house")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistNameLabel.adjustsFontSizeToFitWidth = false
        playlistNameLabel.lineBreakMode = .byTruncatingTail
        
        let imageSize: CGFloat = contentView.height-70
        
        playlistCoverImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(imageSize)
            maker.top.equalToSuperview().offset(5)
            maker.centerX.equalToSuperview()
        }
        
        playlistNameLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(playlistCoverImageView.snp.centerX)
            maker.top.equalTo(playlistCoverImageView.snp.bottom).offset(5)
        }
        
        creatorNameLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(playlistCoverImageView.snp.centerX)
            maker.top.equalTo(playlistNameLabel.snp.bottom).offset(5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    func configure(with viewModel: FeaturePlaylistCellViewModel){
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
    }
}
