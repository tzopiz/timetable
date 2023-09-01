//
//  DataCacheManager.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.07.2023.
//

import Foundation
import SystemConfiguration


class DataCacheManager {
    private let cacheFileName = "timetableCache.json"
    private var cache: [String: StudyWeek] = [:]
    
    init() { loadCacheFromFile() }
    
    /// Загружает данные расписания с указанной даты.
    ///
    /// Если кэшированные данные для запрошенной даты доступны, они будут использованы.
    /// В противном случае будет выполнен сетевой запрос для загрузки данных с сервера.
    ///
    /// - Parameters:
    ///   - firstDay: Дата, с которой необходимо загрузить расписание.
    ///   - needUpdate: Нужно ли загружать данные из интернета заново или использовать кешированные данные
    ///   - completion: Замыкание, вызываемое после загрузки данных.
    ///                 Принимает объект типа `StudyWeek` или `nil` в случае ошибки.
    func loadTimetableData(with firstDay: String, completion: @escaping (StudyWeek?, Error?) -> Void) {
        guard let url = getUrl(from: firstDay) else {
            completion(nil, NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid get url"]))
            return
        }
        let weekKey = "\(url)\(firstDay)"
        if !isInternetAvailable() {
            getDownloadedTimetable(with: firstDay) { cachedData in
                completion(cachedData, nil)
            }
        } else {
            APIManager.shared.loadTimetableData(with: firstDay) { [weak self] studyWeek in
                guard let self = self else { return }
                if let cachedData = getCachedData(for: weekKey) {
                    if studyWeek != cachedData {
                        completion(studyWeek, nil)
                        if UserDefaults.standard.CachingTimetable {
                            self.cacheData(studyWeek, for: weekKey)
                        }
                    } else { completion(cachedData, nil) }
                } else {
                    completion(studyWeek, nil)
                    if UserDefaults.standard.CachingTimetable {
                        self.cacheData(studyWeek, for: weekKey)
                    }
                }
            }
        }
    }
    func getDownloadedTimetable(with firstDay: String, completion: @escaping (StudyWeek?) -> Void) {
        guard let url = getUrl(from: firstDay) else {
            completion(nil)
            return
        }
        let weekKey = "\(url)\(firstDay)"
        if let cachedData = getCachedData(for: weekKey) { completion(cachedData) }
        else { completion(nil) }
    }
    private func getUrl(from str: String) -> URL? {
        let timeInterval: String
        if str == "\(Date())".components(separatedBy: " ")[0] { timeInterval = "" }
        else { timeInterval = "/" + str }
        let urlString = UserDefaults.standard.link + timeInterval
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    func clearCache() {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("Не удалось получить доступ к директории кеша.")
            return
        }
        let cacheFileURL = cacheDirectory.appendingPathComponent(cacheFileName)
        do { try FileManager.default.removeItem(at: cacheFileURL) }
        catch { print("Ошибка при удалении кеша: \(error)") }
    }
    func calculateCacheSize() -> String {
        guard FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first != nil else {
            return "(0.0 кб)"
        }

        do {
            var totalCacheSizeInBytes = 0
            for (_, studyWeek) in cache {
                let encoder = JSONEncoder()
                let encodedCache = try encoder.encode(studyWeek)
                totalCacheSizeInBytes += encodedCache.count
            }
            
            let totalCacheSizeInKilobytes = Double(totalCacheSizeInBytes) / 1024.0
            let totalCacheSizeInMegabytes = totalCacheSizeInKilobytes / 1024.0

            if totalCacheSizeInMegabytes >= 1.0 {
                return String(format: "%.2f мб", totalCacheSizeInMegabytes)
            } else {
                return String(format: "%.2f кб", totalCacheSizeInKilobytes)
            }
        } catch {
            print("Ошибка при расчете размера кеша: \(error)")
            return "(0.0 кб)"
        }
    }
    
    // MARK: - Private

    private func getCachedData(for week: String) -> StudyWeek? { return cache[week] }
    private func cacheData(_ data: StudyWeek, for week: String) {
        cache[week] = data
        saveCacheToFile()
    }
    private func loadCacheFromFile() {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return }
        let cacheFileURL = cacheDirectory.appendingPathComponent(cacheFileName)
        
        do {
            let data = try Data(contentsOf: cacheFileURL)
            let decoder = JSONDecoder()
            let decodedCache = try decoder.decode([String: StudyWeek].self, from: data)
            cache = decodedCache
        } catch {
            if UserDefaults.standard.CachingTimetable { print("Ошибка при загрузке кеша из файла: \(error)") }
        }
    }
    private func saveCacheToFile() {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return }
        let cacheFileURL = cacheDirectory.appendingPathComponent(cacheFileName)
        
        do {
            let encoder = JSONEncoder()
            let encodedCache = try encoder.encode(cache)
            try encodedCache.write(to: cacheFileURL)
        } catch { print("Ошибка при сохранении кеша в файл: \(error)") }
    }
    
    private func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else { return false }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) { return false }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return isReachable && !needsConnection
    }
}
