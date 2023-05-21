//
//  AuthViewModel.swift
//  Messenger
//
//  Created by Ngọc Lê on 01/05/2023.
//


import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            
        } catch {
            print("DEBUG: Failed to sigin with error\(error.localizedDescription)")
        
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user;
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let userMerge = convertUserModelToDictionary(user: user);
            try await Firestore.firestore().collection("users").document(user.id).setData(userMerge)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error\(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error\(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
         let dictionary = snapshot.data()
        let id = dictionary?["id"] as? String ?? ""
        let email = dictionary?["email"] as? String ?? ""
        let fullName = dictionary?["fullName"] as? String ?? ""
        self.currentUser = User(id: id, fullName: fullName, email: email)
    }
    
}
func convertUserModelToDictionary(user: User) -> [String : Any] {

    let userData = [
        "id" : user.id,
        "email": user.email,
        "fullName": user.fullName
    ]
    
    return userData
}
