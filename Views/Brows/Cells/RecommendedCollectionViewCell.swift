//
//  RecommendedCollectionViewCell.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 21/1/22.
//
import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        image.image = UIImage(systemName: "house")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackNameLabel.adjustsFontSizeToFitWidth = false
        trackNameLabel.lineBreakMode = .byTruncatingTail
        
        let imageSize: CGFloat = contentView.height-4
        
        albumCoverImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(imageSize)
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(5)
        }
        
        trackNameLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(5)
            maker.leading.equalTo(albumCoverImageView.snp.trailing).offset(8)
            maker.trailing.equalToSuperview()
            maker.height.equalTo(25)
        }
        
        artistNameLabel.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(5)
            maker.leading.equalTo(trackNameLabel.snp.leading)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: RecommendedTrackViewModel){
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
