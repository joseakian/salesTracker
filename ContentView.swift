//
//  ContentView.swift
//  Ventas
//
//  Created by José A-Kián Serrano Sam on 26/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var ventas: [Venta] = []
    @State private var mostrarAgregarVenta = false
    
    var totalVentas: Double {
        ventas.reduce(0) { $0 + $1.monto }
    }
    
    var promedioVentas: Double {
        ventas.isEmpty ? 0 : totalVentas / Double(ventas.count)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Tarjetas de Resumen
                HStack {
                    TarjetaResumen(
                        titulo: "Total",
                        valor: String(format: "$%.2f", totalVentas),
                        color: .blue
                    )
                    
                    TarjetaResumen(
                        titulo: "Promedio",
                        valor: String(format: "$%.2f", promedioVentas),
                        color: .green
                    )
                }
                .padding()
                
                // Lista de Ventas
                List {
                    ForEach(ventas) { venta in
                        VentaRow(venta: venta)
                    }
                    .onDelete(perform: eliminarVenta)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Mis Ventas")
            .toolbar {
                Button(action: {
                    mostrarAgregarVenta = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
            .sheet(isPresented: $mostrarAgregarVenta) {
                AgregarVentaView(ventas: $ventas)
            }
        }
    }
    
    func eliminarVenta(at offsets: IndexSet) {
        ventas.remove(atOffsets: offsets)
    }
}

// Modelo de Datos
struct Venta: Identifiable {
    let id = UUID()
    let cliente: String
    let monto: Double
    let fecha: Date
    let producto: String
}

// Tarjeta de Resumen
struct TarjetaResumen: View {
    let titulo: String
    let valor: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(titulo)
                .font(.caption)
                .foregroundColor(.gray)
            Text(valor)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

// Fila de Venta
struct VentaRow: View {
    let venta: Venta
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(venta.cliente)
                    .font(.headline)
                Text(venta.producto)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(String(format: "$%.2f", venta.monto))
                    .font(.headline)
                    .foregroundColor(.green)
                Text(venta.fecha, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

// Graficas
struct GraficaVentas: View {
    let ventas: [Venta]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(Array(ventasPorDia().prefix(7)), id: \.key) { dia, total in
                VStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 40, height: CGFloat(total / 10))
                    
                    Text(dia)
                        .font(.caption2)
                }
            }
        }
        .frame(height: 200)
        .padding()
    }
    
    func ventasPorDia() -> [(key: String, value: Double)] {
        // Lógica simplificada
        return [("L", 100), ("M", 150), ("X", 80)]
    }
}
