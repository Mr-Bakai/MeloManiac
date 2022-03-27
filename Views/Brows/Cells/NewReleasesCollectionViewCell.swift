//
//  NewReleasesCollectionViewCell.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 21/1/22.

import Foundation
import UIKit
import SDWebImage
import SnapKit

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "house")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumNameLabel.adjustsFontSizeToFitWidth = false
        albumNameLabel.lineBreakMode = .byTruncatingTail
        
        let imageSize: CGFloat = contentView.height-10
        
        albumCoverImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(imageSize)
            maker.top.equalToSuperview().offset(5)
            maker.leading.equalToSuperview().offset(5)
        }
        
        albumNameLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(5)
            maker.height.equalTo(25)
            maker.leading.equalTo(albumCoverImageView.snp.trailing).offset(5)
            maker.trailing.equalToSuperview().offset(10)
        }
        
        artistNameLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(albumNameLabel.snp.leading)
            maker.top.equalTo(albumNameLabel.snp.bottom)
            maker.height.equalTo(25)
        }
        
        numberOfTracksLabel.snp.makeConstraints { maker in
            maker.bottom.equalTo(albumCoverImageView.snp.bottom)
            maker.leading.equalTo(artistNameLabel.snp.leading)
            maker.height.equalTo(25)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel){
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
    }
}
