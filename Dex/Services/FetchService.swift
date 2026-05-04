//
//  FetchService.swift
//  Dex
//
//  Created by German Battiston on 04/05/2026.
//

import Foundation

struct FetchService {
    enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    public func fetchPokemon(_ id: Int16) async throws -> FetchedPokemon {
        let fetchURL = baseURL.appending(path: String(id))
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let fetchedPokemon = try decoder.decode(FetchedPokemon.self, from: data)
        
        print("Fetched Pokemon \(fetchedPokemon.id): \(fetchedPokemon.name)")
        
        return fetchedPokemon
    }
}
