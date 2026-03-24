import SwiftUI
import Combine

// MARK: - WeatherView
struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    searchBar
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(error)
                    } else if let weather = viewModel.weather {
                        weatherContent(weather)
                    } else {
                        emptyView
                    }
                }
                .padding()
            }
            .navigationTitle("🌤️ Weather")
        }
    }

    // MARK: - Subviews
    private var searchBar: some View {
        HStack {
            TextField("Nhập thành phố...",
                      text: $viewModel.cityName)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Button {
                Task {
                    await viewModel.fetchWeather()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .padding()
                    .background(
                        viewModel.cityName.isEmpty ?
                        Color.gray :
                        Color.blue
                    )
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.cityName.isEmpty)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Đang tải...")
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 50)
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "cloud.sun")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("Nhập tên thành phố\nđể xem thời tiết!")
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 50)
    }

    private func weatherContent(
        _ weather: WeatherResponse) -> some View {
        VStack(spacing: 20) {

            Text(weather.name)
                .font(.largeTitle)
                .bold()

            Text(String(format: "%.1f°C",
                       weather.main.tempCelsius))
                .font(.system(size: 70, weight: .thin))
                .foregroundColor(.blue)

            Text(weather.weather.first?
                .description.capitalized ?? "")
                .font(.title3)
                .foregroundColor(.secondary)

            HStack(spacing: 0) {
                detailItem(
                    icon: "humidity",
                    value: "\(weather.main.humidity)%",
                    title: "Độ ẩm")

                Divider().frame(height: 50)

                detailItem(
                    icon: "wind",
                    value: String(format: "%.1f m/s",
                                 weather.wind.speed),
                    title: "Gió")
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(16)
        }
    }

    private func detailItem(
        icon: String,
        value: String,
        title: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(value)
                .font(.headline)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
