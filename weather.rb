require 'net/http'
require 'json'
require 'csv'

# Введіть ваш API-ключ
API_KEY = 'd6465aa6274328c67500d8d0b06f71f4'

def get_weather_data(city, api_key)
  url = URI("http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric")
  response = Net::HTTP.get(url)
  JSON.parse(response)
end

def save_weather_data_to_csv(data, file_name)
  city_name = data['name']
  temperature = data['main']['temp']
  humidity = data['main']['humidity']
  wind_speed = data['wind']['speed']

  CSV.open(file_name, "wb") do |csv|
    # Записуємо заголовки
    csv << ["Місто", "Температура (°C)", "Вологість (%)", "Швидкість вітру (м/с)"]
    # Записуємо дані
    csv << [city_name, temperature, humidity, wind_speed]
  end

  puts "Дані про погоду для #{city_name} успішно збережені у файлі #{file_name}."
end

if __FILE__ == $0
  city = 'Kyiv'
  data = get_weather_data(city)
  save_weather_data_to_csv(data, 'weather_data.csv')
end
