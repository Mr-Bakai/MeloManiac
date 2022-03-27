//
//  PlayerViewController.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 19/3/22.
//
import Foundation
import UIKit
import SnapKit
import SDWebImage


protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackwards()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    /// THIS NEEDS TO BE RECAPPED
    private let controlsView = PlayerControlsView()
    /// THIS NEEDS TO BE RECAPPED
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaInsets.top)
            maker.leading.equalToSuperview()
            maker.width.height.equalTo(view.width)
        }
        
        controlsView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(10)
            maker.top.equalTo(imageView.snp.bottom).offset(10)
            maker.width.equalTo(view.width-20)
            maker.height.equalTo(view.height-imageView.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
            maker.bottom.equalToSuperview().inset(25)
        }
    }
    
    
    /// THIS NEEDS TO BE RECAPPED
    private func configure(){
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(with: PlayerControlsViewViewModel(
                                title: dataSource?.songName,
                                subtitle: dataSource?.subtitle)
        )
    }
    
    private func configureBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction(){
        //Some action
    }
    
    func refreshUI(){
        configure()
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackwards()
    }
}
