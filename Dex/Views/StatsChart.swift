//
//  StatsChart.swift
//  Dex
//
//  Created by German Battiston on 06/05/2026.
//

import SwiftUI
import Charts

struct StatsChart: View {
    var pokemon: Pokemon
    
    var body: some View {
        Chart(pokemon.stats) { stat in
            BarMark(x: .value("Value", stat.value),
                    y: .value("Stat", stat.name)
            )
            .annotation(position: .trailing) {
                Text("\(stat.value)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 300)
        .padding()
        .foregroundStyle(pokemon.typeColor)
        .chartXScale(domain: 0...pokemon.hishestStat.value + 10)
    }
}

#Preview {
    StatsChart(pokemon: PersistenceController.previewPokemon)
}
