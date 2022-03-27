//
//  SearchResultResponse.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 13/2/22.
//

import Foundation


struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
    
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]
    
}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
    
}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
