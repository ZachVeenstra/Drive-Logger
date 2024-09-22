import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject private var drivesDataModel: DrivesDataModel
    @State private var totalProgress: Double = 0
    @State private var nightProgress: Double = 0

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
                    let userTotalGoal: Double = Double(UserDefaults.standard.totalTimeGoal * TimeConverter.secondsInHour)
                    let userNightGoal: Double = Double(UserDefaults.standard.nightTimeGoal * TimeConverter.secondsInHour)
                    
                    totalProgress = Double(drivesDataModel.getTotalSeconds()) / userTotalGoal
                    nightProgress = Double(drivesDataModel.getTotalNightSeconds()) / userNightGoal
                }
            }
            .navigationTitle("Drive-Logger")
            .padding()
        }
    }

    private var progressCardSection: some View {
        ProgressCard(totalProgress: totalProgress, nightProgress: nightProgress)
            .padding()
    }

    private var timeViewSection: some View {
        VStack {
            HStack {
                Image(systemName: "car.fill")
                    .foregroundStyle(totalProgress >= 1 ? .completed : .totalProgress)
                    .frame(width: 50)
                
                Text("\(drivesDataModel.getTotalHours())hrs  \(drivesDataModel.getTotalMinutes())mins")
                    .accessibilityIdentifier("TotalTime")
            }

            HStack {
                Image(systemName: "moon.fill")
                    .foregroundStyle(nightProgress >= 1 ? .completed : .nightProgress)
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
