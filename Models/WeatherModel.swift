import Foundation

// MARK: - Weather Models
struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherDetail]
    let wind: Wind
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int

    var tempCelsius: Double {
        temp - 273.15
    }
}

struct WeatherDetail: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}


