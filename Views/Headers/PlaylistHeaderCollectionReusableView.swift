//
//  PlaylistHeaderCollectionReusableView.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 23/1/22.
//
import UIKit
import SDWebImage
import SnapKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "photo")
        return image
    }()
    
    private let playAllButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        
        let image = UIImage(systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        
        button.setImage(image, for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapPlayAll(){
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height/1.8
      
        image.snp.makeConstraints { maker in
            maker.height.width.equalTo(imageSize)
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(image.snp.bottom).offset(5)
            maker.leading.equalToSuperview().offset(5)
            maker.height.equalTo(25)
            maker.width.equalTo(width-20)
        }
        
        descriptionLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(nameLabel.snp.leading)
            maker.top.equalTo(nameLabel.snp.bottom).offset(5)
            maker.bottom.equalTo(playAllButton.snp.top).offset(2)
            maker.height.equalTo(44)
            maker.width.equalTo(width-20)
        }
        
        ownerLabel.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            maker.leading.equalTo(descriptionLabel.snp.leading)
            maker.height.equalTo(25)
            maker.width.equalTo(width-20)
        }
        
        playAllButton.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().inset(10)
            maker.trailing.equalToSuperview().inset(10)
            maker.height.width.equalTo(60)
        }
    }
    
    func configure(with viewModel: PlaylistHeaderViewViewModel){
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        image.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
