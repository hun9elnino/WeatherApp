import Foundation

// MARK: - Weather Error
enum WeatherError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case cityNotFound
    case noInternet

    var errorDescription: String? {
        switch self {
        case .invalidURL:      return "URL không hợp lệ"
        case .invalidResponse: return "Response không hợp lệ"
        case .invalidData:     return "Không thể đọc data"
        case .cityNotFound:    return "Không tìm thấy thành phố"
        case .noInternet:      return "Không có kết nối mạng"
        }
    }
}

// MARK: - WeatherService
class WeatherService {

    private let apiKey  = "7865a80879b1812d44123c1b225a7eb9"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(city: String) async throws -> WeatherResponse {

        let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)"

        guard let encodedURL = urlString
            .addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL)
        else {
            throw WeatherError.invalidURL
        }

        print("🌐 URL: \(url)")
        
        let (data, response) = try await URLSession
            .shared.data(from: url)

        guard let httpResponse = response
                as? HTTPURLResponse
        else {
            throw WeatherError.invalidResponse
        }
        
        // ✅ Thêm dòng này để debug
           print("📡 Status Code: \(httpResponse.statusCode)")

           // ✅ Thêm dòng này để xem raw JSON
           print("📦 Raw JSON: \(String(data: data, encoding: .utf8) ?? "nil")")

        switch httpResponse.statusCode {
        case 200: break
        case 404: throw WeatherError.cityNotFound
        default:  throw WeatherError.invalidResponse
        }

        do {
            return try JSONDecoder()
                .decode(WeatherResponse.self, from: data)
        } catch {
            print("❌ Decode Error: \(error)")
            throw WeatherError.invalidData
        }
    }
}
