//
//  ContentView.swift
//  LocationAndPlaceLookup
//
//  Created by Carolyn Ballinger on 4/6/25.
//

import SwiftUI

struct ContentView: View {
    @State var locationManager = LocationManager()
    @State var selectedPlace: Place?
    @State private var sheetIsPresented = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(selectedPlace?.name ?? "n/a")
                    .font(.title2)
                Text(selectedPlace?.address ?? "n/a")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("\(selectedPlace?.latitude ?? 0.0), \(selectedPlace?.longitude ?? 0.0)")
                .font(.title3)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                sheetIsPresented.toggle()
            } label: {
                Image(systemName: "location.magnifyingglass")
                Text("Location Search")
            }
            .buttonStyle(.borderedProminent)
            .font(.title2)
        }
        .padding()
        .task {
            // Get user location once when the view appears
            // handle case if user already authoized location use
            if let location = locationManager.location {
                selectedPlace = await Place(Location: location)
            }
            // Setup a location callback - this handles when new locations come in after the app launches - it will catch the first locationUpdate, which is what we need, otherwise we won't see the information in the VStack update after the user first authorizes location use
            locationManager.locationUpdated = { location in
                // We know we now have a new location, so use it to updated the selectedPlace
                Task {
                    selectedPlace = await Place(Location: location)
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            PlaceLookupView(locationManager: locationManager, selectedPlace: $selectedPlace)
        }
    }
    
}


#Preview {
    ContentView()
}
