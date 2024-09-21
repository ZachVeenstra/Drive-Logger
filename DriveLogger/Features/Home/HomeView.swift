import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject private var drivesDataModel: DrivesDataModel
    @State private var totalProgress: Double  = 0
    @State private var nightProgress: Double  = 0

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let isLandscape = geometry.size.width > geometry.size.height
                
                Group {
                    if isLandscape {
                        HStack {
                            progressCardSection
                            VStack {
                                timeViewSection
                                buttonSection
                            }
                        }
                    } else {
                        VStack {
                            progressCardSection
                            timeViewSection
                            buttonSection
                        }
                    }
                }
                .padding()
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                .onAppear {
                    totalProgress = Double(drivesDataModel.getTotalSeconds()) / Double(50 * TimeConverter.secondsInHour)
                    nightProgress = Double(drivesDataModel.getTotalNightSeconds()) / Double(10 * TimeConverter.secondsInHour)
                }
            }
            .navigationTitle("Drive-Logger")
            .padding()
        }
    }

    // Extract the ProgressCard as a separate view for reuse
    private var progressCardSection: some View {
        ProgressCard(totalProgress: totalProgress, nightProgress: nightProgress)
            .padding()
    }

    // Extract the time view as a separate view for reuse
    private var timeViewSection: some View {
        VStack {
            HStack {
                Image(systemName: "car.fill")
                    .foregroundStyle(totalProgress >= 1 ? .green : .yellow)
                    .frame(width: 50)
                
                Text("\(drivesDataModel.getTotalHours())hrs  \(drivesDataModel.getTotalMinutes())mins")
                    .accessibilityIdentifier("TotalTime")
            }

            HStack {
                Image(systemName: "moon.fill")
                    .foregroundStyle(totalProgress >= 1 ? .green : .accentColor)
                    .frame(width: 50)
                
                Text("\(drivesDataModel.getTotalNightHours())hrs  \(drivesDataModel.getTotalNightMinutes())mins")
                    .accessibilityIdentifier("NightTime")
            }
        }
        .fontWeight(.semibold)
        .font(.largeTitle)
        .minimumScaleFactor(0.25)
        .lineLimit(1)
    }
    
    private var buttonSection: some View {
        VStack {
            NavigationLink(destination: DriveView()) {
                Text("Start Drive")
            }
            .buttonStyle(ActionButtonStyle())
            
            NavigationLink(destination: LoggedDrivesView()) {
                Text("Logged Drives")
            }
            .buttonStyle(ActionButtonStyle())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let moc = DataController.shared.container.viewContext
    
    static var previews: some View {
        HomeView()
            .environmentObject(DrivesDataModel(moc: moc))
    }
}
