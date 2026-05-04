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
                        
                    }
                }
            }
            Text("Select a Pokemon")
        }
    }

}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
