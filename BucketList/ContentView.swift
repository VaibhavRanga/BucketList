//
//  ContentView.swift
//  BucketList
//
//  Created by Vaibhav Ranga on 21/06/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        
        if viewModel.isUnlocked {
            ZStack(alignment: .bottomTrailing) {
                MapReader { proxy in
                    Map() {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.hybridMap ? .hybrid : .standard)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                }
                
                Button {
                    viewModel.hybridMap.toggle()
                } label: {
                    Image(systemName: "map.circle")
                        .font(.title)
                        .foregroundStyle(viewModel.hybridMap ? .white : .black)
                        .offset(x: -10)
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
