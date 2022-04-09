//
//  PlayerControlsView.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 19/3/22.
//

import Foundation
import UIKit
import SnapKit

protocol PlayerControlsViewDelegate: AnyObject{
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}


final class PlayerControlsView: UIView {
    weak var delegate: PlayerControlsViewDelegate?
    
    private var isPlaying = true
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "This is my song"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Drake (feat. Bakai)"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(playPauseButton)
        
        
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
         
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc private func didTapPlayPause(){
        // this will give you the reversed state of bool
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        
        let play = UIImage(systemName: "play.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        let pause = UIImage(systemName: "pause",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        
        // Update the icon
        playPauseButton.setImage(isPlaying ? play : pause , for: .normal)
    }
    
    @objc private func didTapBack(){
        delegate?.playerControlsViewDidTapBackwardsButton(self)
    }
    
    @objc private func didTapForward(){
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
//        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
//        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom+10, width: width, height: 50)
        
//        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom+20, width: width-20, height: 44)
        
        let buttonSize: CGFloat = 60
        let playPausePosition = (width - buttonSize)/2
        
//        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: volumeSlider.bottom + 30, width: buttonSize, height: buttonSize)

//        backButton.frame = CGRect(x: playPauseButton.left-80-buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        
//        forwardButton.frame = CGRect(x: playPauseButton.right+80, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        
        
        nameLabel.snp.makeConstraints { maker in
            maker.leading.top.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        subtitleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.width.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        volumeSlider.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            maker.width.equalToSuperview().inset(10)
            maker.height.equalTo(44)
        }
        
        playPauseButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(playPausePosition)
            maker.top.equalTo(volumeSlider.snp.bottom).offset(30)
            maker.height.width.equalTo(buttonSize)
        }
        
        backButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.top.equalTo(playPauseButton.snp.top)
            maker.height.width.equalTo(buttonSize)
        }
        
        forwardButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview()
            maker.top.equalTo(playPauseButton.snp.top)
            maker.height.width.equalTo(buttonSize)
        }
    }
    
    /// THIS NEEDS TO BE RECAPPED
    func configure(with viewModel: PlayerControlsViewViewModel){
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subtitle: String?
}
