//
//  AlbumViewController.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 22/1/22.
//
import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    private var viewModels = [AlbumCollectionViewCellViewModel]()
    private var tracks = [AudioTrack]()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        
        // Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,leading: 2,bottom: 2,trailing: 2)
        
        // Vertical group in horizontal group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            ),
            subitem: item,
            count: 1
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        return section
    }))
    
    init(album: Album){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier
        )
        collectionView.register(AlbumTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getAlbumsDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumCollectionViewCellViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "-"
                            )
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}


// MARK: -CollectionView
extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    // This is for headerView
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                for: indexPath) as? PlaylistHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerViewModel = PlaylistHeaderViewViewModel(
            name: album.name,
            ownerName: album.artists.first?.name,
            description: "Release Date: \(String.formattedDate(string: album.release_date))",
            artworkURL: URL(string: album.images.first?.url ?? ""))
        header.configure(with: headerViewModel
        )
        header.delegate = self
        return header
    }
    
    // MARK: - CLICK
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
}

// MARK: -Extension
extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        
        let tracksWithAlbum :[AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
        })
        
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
}
