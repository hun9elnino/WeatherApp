import SwiftUI
import Foundation
import Combine

// MARK: - WeatherViewModel
@MainActor
class WeatherViewModel: ObservableObject {

    @Published var weather: WeatherResponse?
    @Published var isLoading    = false
    @Published var errorMessage: String?
    @Published var cityName     = ""

    private let service = WeatherService()

    func fetchWeather() async {
        guard !cityName.trimmingCharacters(
            in: .whitespaces).isEmpty else {
            errorMessage = "Vui lòng nhập tên thành phố!"
            return
        }

        isLoading    = true
        errorMessage = nil
        weather      = nil

        do {
            weather = try await service
                .fetchWeather(city: cityName)
        } catch let error as WeatherError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Có lỗi xảy ra!"
        }

        isLoading = false
    }
}
