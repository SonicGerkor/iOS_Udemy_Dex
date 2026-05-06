//
//  PokemonDetail.swift
//  Dex
//
//  Created by German Battiston on 06/05/2026.
//

import SwiftUI
import CoreData

struct PokemonDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject private var pokemon: Pokemon
    
    @State private var showShiny = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.leading)
                    .padding(.trailing)
                    .shadow(color: .black, radius: 6)
                
                AsyncImage(url: pokemon.sprite) { image in
                    image
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 80)
                        .shadow(color: .black, radius: 8)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .shadow(color: .white, radius: 7)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color(type.capitalized))
                        .clipShape(.capsule)
                }
                
                Spacer()
                
                Button {
                    pokemon.favorite.toggle()
                    
                    do {
                        try viewContext.save()
                    } catch {
                      print(error)
                    }
                } label: {
                    Image(systemName: pokemon.favorite ? "star.fill" : "star")
                        .font(.largeTitle)
                        .tint(.yellow)
                }
            }
            .padding()
        }
        .navigationTitle(pokemon.name!.capitalized)
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView()
            .environmentObject(PersistenceController.previewPokemon)
    }
}
