//
//  GoogleSignIn.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/6/26.
//
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

class GoogleSignInViewModel: ObservableObject {
    
    @StateObject var vm = AuthVM()
    
    func signIn(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let rootViewController =
            UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first?.rootViewController
        else {
            completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller."])))
            return
        }

        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        ) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -2, userInfo: [NSLocalizedDescriptionKey: "Missing user or token."])))
                return
            }
            
            let name = user.profile?.name ?? ""
            let email = user.profile?.email ?? ""
            
            print("Completed Google Sign In for \(name) (\(email)")

            completion(.success([idToken, name, email]))
        }
    }
}
