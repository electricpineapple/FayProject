//

import Foundation

struct Token: Codable {
    let access: String
    let accessExpires: Date?
    func accessExpired() -> Bool {
        guard let accessExpires = accessExpires, accessExpires > Date.now else {
            return true
        }
        return false
    }
}

protocol TokenStorage {
    func removeTokenFromStorage() async throws
    func saveTokenToStorage(_ token: Token) async throws
    func getTokenFromStorage() async throws -> Token
}

class KeychainTokenStorage: TokenStorage {
    func getTokenFromStorage() async throws -> Token {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.onrender.node-api-for-candidates",
            kSecAttrAccount as String: "FayJsonWebToken",
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard result == errSecSuccess else {
            throw FayError.keychainRetrieveError
        }
        
        guard
            let keychainItem = item as? [String : Any],
            let keychainData = keychainItem[kSecValueData as String] as? Data
        else {
            throw FayError.keychainRetrieveError
        }
        
        let tokens = try JSONDecoder().decode(Token.self, from: keychainData)
        return tokens
    }
    
    func saveTokenToStorage(_ token: Token) async throws {
        let data = try JSONEncoder().encode(token)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.onrender.node-api-for-candidates",
            kSecAttrAccount as String: "FayJsonWebToken",
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        let queryCF = query as CFDictionary
        let result = SecItemAdd(queryCF, nil)
        
        if result == errSecDuplicateItem {
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: "com.onrender.node-api-for-candidates",
                kSecAttrAccount as String: "FayJsonWebToken",
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            let updateAttr = [
                kSecValueData: data
            ]
            let updateResult = SecItemUpdate(updateQuery as CFDictionary, updateAttr as CFDictionary)
            guard updateResult == errSecSuccess else {
                throw FayError.keychainUpdate
            }
        }
        else if result != errSecSuccess {
            throw FayError.keychainSaveError
        }
    }
    
    func removeTokenFromStorage() async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.onrender.node-api-for-candidates",
            kSecAttrAccount as String: "FayJsonWebToken",
        ]
        
        let result = SecItemDelete(query as CFDictionary)
        if result != errSecSuccess {
            throw FayError.keychainDelete
        }

    }
}
