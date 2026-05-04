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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.name, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    
    private let fetcher = FetchService()

    var body: some View {
        NavigationView {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink {
                        Text(pokemon.name ?? "??")
                    } label: {
                        Text(pokemon.name ?? "??")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        getPokemon()
                    }
                }
            }
            Text("Select a Pokemon")
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
