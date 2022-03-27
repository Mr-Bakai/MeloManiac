//
//  AlbumTrackCollectionViewCell.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 23/1/22.
//

import Foundation
import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"

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
        
        trackNameLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(5)
            maker.leading.equalToSuperview().offset(5)
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
    }
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
