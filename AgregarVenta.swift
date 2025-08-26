//
//  AgregarVenta.swift
//  Ventas
//
//  Created by José A-Kián Serrano Sam on 26/08/25.
//

import SwiftUI

struct AgregarVentaView: View {
    @Binding var ventas: [Venta]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var cliente = ""
    @State private var producto = ""
    @State private var monto = ""
    @State private var fecha = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información de la Venta")) {
                    TextField("Nombre del Cliente", text: $cliente)
                    
                    TextField("Producto/Servicio", text: $producto)
                    
                    TextField("Monto", text: $monto)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                }
                
                Section {
                    Button(action: guardarVenta) {
                        Text("Guardar Venta")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Nueva Venta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func guardarVenta() {
        guard let montoDouble = Double(monto),
              !cliente.isEmpty,
              !producto.isEmpty else { return }
        
        let nuevaVenta = Venta(
            cliente: cliente,
            monto: montoDouble,
            fecha: fecha,
            producto: producto
        )
        
        ventas.append(nuevaVenta)
        presentationMode.wrappedValue.dismiss()
    }
}
