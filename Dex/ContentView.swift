//
//  ContentView.swift
//  Dex
//
//  Created by German Battiston on 04/05/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest<Pokemon>(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    )
    
    private var pokedex: FetchedResults<Pokemon>
    
    @State private var searchText = ""
    
    private let fetcher = FetchService()
    private var dynamicPredicate: NSPredicate {
        var predicates = [NSPredicate]()
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[c] %@", searchText))
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(pokedex) { p in
                    NavigationLink {
                        Text(p.name?.capitalized ?? "??")
                    } label: {
                        AsyncImage(url: p.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        
                        VStack(alignment: .leading) {
                            Text(p.name!.capitalized)
                                .fontWeight(.bold)
                            
                            HStack {
                                ForEach(p.types!, id: \.self) { type in
                                    Text(type.capitalized)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color(type.capitalized))
                                        .clipShape(.capsule)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pokedex")
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search for a Pokémon")
            .autocorrectionDisabled()
            .onChange(of: searchText) {
                pokedex.nsPredicate = dynamicPredicate
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        
                    }
                }
            }
            .onAppear {
                getPokemon()
            }
        }
    }

    private func getPokemon() {
        Task {
            for id: Int16 in 1..<152 {
                do {
                    let fetchedPokemon = try await fetcher.fetchPokemon(id)
                    let pokemon = Pokemon(context: viewContext)
                    pokemon.id = fetchedPokemon.id
                    pokemon.name = fetchedPokemon.name
                    pokemon.types = fetchedPokemon.types
                    pokemon.hp = fetchedPokemon.hp
                    pokemon.attack = fetchedPokemon.attack
                    pokemon.defense = fetchedPokemon.defense
                    pokemon.specialAttack = fetchedPokemon.specialAttack
                    pokemon.specialDefense = fetchedPokemon.specialDefense
                    pokemon.speed = fetchedPokemon.speed
                    pokemon.sprite = fetchedPokemon.sprite
                    pokemon.shiny = fetchedPokemon.shiny
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
