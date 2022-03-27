//
//  LibraryViewController.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 9/1/22.
//

import UIKit

final class LibraryViewController: UIViewController {
    
    private let playlistsVC = LibraryPlaylistViewController()
    private let albumsVC = LibraryAlbumsViewController()
    private let toggleView = LibraryToggleView()
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(toggleView)
        
        toggleView.delegate = self
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        addChildren()
        
        updateBarButtons()
    }
    
    private func addChildren(){
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 55)
        
        scrollView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(55)
            maker.bottom.equalTo(view.safeAreaInsets)
        }
    }
    
    private func updateBarButtons(){
        switch toggleView.state {
            case .playlist:
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(didTapAdd))
            case .album:
                navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAdd(){
        // This will show alert when you tap on add button(plus), playlistVC is the child controller
        playlistsVC.showCreatePlaylistAlert()
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-100) {
            toggleView.updateState(for: .album)
            updateBarButtons()
        } else {
            toggleView.updateState(for: .playlist)
            updateBarButtons()
        }
    }
}


extension LibraryViewController: LibraryToggleViewDelegate {
    
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
}
