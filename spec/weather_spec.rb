require 'net/http'
require 'json'
require 'csv'
require 'rspec'

# Подключаем функции из вашего основного файла
require_relative '../weather'  # Исправленный путь

RSpec.describe 'Weather API' do
  let(:city) { 'Kyiv' }
  let(:api_key) { 'd6465aa6274328c67500d8d0b06f71f4' }  # Замените на ваш настоящий ключ
  let(:file_name) { 'weather_data.csv' }

  context 'Обробка даних' do
    it 'вміщує ключові поля: name, main, wind' do
      data = get_weather_data(city, api_key)

      expect(data).to have_key('name')
      expect(data['main']).to have_key('temp')
      expect(data['main']).to have_key('humidity')
      expect(data['wind']).to have_key('speed')
    end
  end

  context 'Збереження даних у CSV файл' do
    it 'створює CSV файл з правильними даними' do
      # Отримуємо дані
      data = get_weather_data(city, api_key)

      # Зберігаємо дані у CSV
      save_weather_data_to_csv(data, file_name)

      # Перевіряємо, що файл існує
      expect(File.exist?(file_name)).to be true

      # Читаємо вміст файлу
      csv_content = CSV.read(file_name)

      # Перевіряємо заголовки
      expect(csv_content[0]).to eq(["Місто", "Температура (°C)", "Вологість (%)", "Швидкість вітру (м/с)"])

      # Перевіряємо дані (наприклад, для міста Київ)
      expect(csv_content[1][0]).to eq('Kyiv')
      expect(csv_content[1][1].to_f).to be_a(Float)
      expect(csv_content[1][2].to_f).to be_a(Float)
      expect(csv_content[1][3].to_f).to be_a(Float)
    end
  end
end
