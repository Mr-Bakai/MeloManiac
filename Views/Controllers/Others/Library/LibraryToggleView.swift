//
//  LibraryToggleView.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 26/3/22.
//

import Foundation
import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    weak var delegate: LibraryToggleViewDelegate?
    
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlist", for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Albums", for: .normal)
        return button
    }()
    
    private let indicator: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumsButton)
        addSubview(indicator)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    
    @objc private func didTapPlaylists(){
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        state = .playlist
        delegate?.libraryToggleViewDidTapPlaylists(self)
    }
    
    @objc private func didTapAlbums(){
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        state = .album
        delegate?.libraryToggleViewDidTapAlbums(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumsButton.frame = CGRect(x: playlistButton.right, y: 0, width: 100, height: 40)
        indicator.frame = CGRect(x: 0, y: playlistButton.bottom, width: 100, height: 3)
        layoutIndicator()
    }
    
    // this takes care of the position of the indicator
    private func layoutIndicator(){
        
        switch state {
        case .playlist:
            indicator.frame = CGRect(
                x: 0,
                y: playlistButton.bottom,
                width: 100,
                height: 3)
            
        case .album:
            indicator.frame = CGRect(
                x: 100,
                y: playlistButton.bottom,
                width: 100,
                height: 3)
        }
    }
    
    
    func updateState(for state: State){
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
