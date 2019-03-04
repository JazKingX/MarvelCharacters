import Foundation

struct MarvelRequestBuilder {
    private let publicKey: String
    private let privateKey: String
    private let baseURLString: String
    
    static var defaultBuilder: MarvelRequestBuilder {
        return MarvelRequestBuilder(
            publicKey: MARVEL_PUBLIC_KEY,
            privateKey: MARVEL_PRIVATE_KEY,
            baseURLString: MARVEL_BASE_URL
        )
    }
    
    init(publicKey: String, privateKey: String, baseURLString: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.baseURLString = baseURLString
    }
    
    func charactersRequest(offset: Int) -> URLRequest {
        return marvelRequest(
            path: "/v1/public/characters",
            parameters: [("offset", "\(offset)"), ("limit", "100")]
        )
    }
    
    private func marvelRequest(path: String, parameters: [(String, String)]) -> URLRequest {
        guard var components = URLComponents(string: baseURLString) else {
            preconditionFailure("Check your BaseURL")
        }
        
        let queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems = queryItems + defaultQueryItems()
        components.path = path
        
        guard let url = components.url else {
            preconditionFailure("Check your BaseURL")
        }
        
        return URLRequest(url: url)
    }
    
    private func defaultQueryItems() -> [URLQueryItem] {
        let timestamp = String(Int(Date().timeIntervalSinceReferenceDate))
        let hash = (timestamp + privateKey + publicKey).MD5()
        
        return [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: hash)
        ]
    }
}

// Credits go to https://stackoverflow.com/questions/32163848/how-to-convert-string-to-md5-hash-using-ios-swift

private extension String {
    func MD5() -> String {
        let originalData = data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            originalData.withUnsafeBytes { originalBytes in
                CC_MD5(originalBytes, CC_LONG(originalData.count), digestBytes)
            }
        }
        
        return digestData
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}
