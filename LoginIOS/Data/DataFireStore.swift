//
//  DataFireStore.swift
//  LoginIOS
//
//  Created by Mañanas on 23/4/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

// Instanciar de Cloud Firestore
// FirebaseApp.configure()

let db = Firestore.firestore()

let coleccion="usuarios"



struct Usuario: Codable {
    var usuario:String
    var nombre:String
    var apellidos:String
    var imagenPerfil:String
}

// Para crear o sobrescribir un solo documento, utilice los siguientes métodos set() específicos del idioma:
//
func saveData(doc:String) {
    
    Task{
        do {
            try await db.collection(coleccion).document(doc).setData([
                "name": "Los Angeles",
                "state": "CA",
                "country": "USA"
            ])
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
}

func readData(doc:String) {

    Task{
        let docRef = db.collection(coleccion).document(doc)

        do {
          let document = try await docRef.getDocument()
          if document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
          } else {
            print("Document does not exist")
          }
        } catch {
          print("Error getting document: \(error)")
        }
    }
    
}

func delData(doc:String) {
    
    Task {
        do {
            try await db.collection(coleccion).document(doc).delete()
            print("Document successfully removed!")
        } catch {
            print("Error removing document: \(error)")
        }
    }
}

func subirArchivo(pathToImage:String){
    // Inicializción de referencias.
    // Create a root reference
    let storageRef = storage.reference()

    // Create a reference to "mountains.jpg"
    let mountainsRef = storageRef.child("mountains.jpg")

    // Create a reference to 'images/mountains.jpg'
    let mountainImagesRef = storageRef.child("images/mountains.jpg")

    // While the file names are the same, the references point to different files
    mountainsRef.name == mountainImagesRef.name            // true
    mountainsRef.fullPath == mountainImagesRef.fullPath    // false
    
    
    
    // File located on disk
    let localFile = URL(string: pathToImage)!

    // Create a reference to the file you want to upload
    let riversRef = storageRef.child("images/rivers.jpg")

    // Upload the file to the path "images/rivers.jpg"
    let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
      guard let metadata = metadata else {
        // Uh-oh, an error occurred!
        return
      }
      // Metadata contains file metadata such as size, content-type.
      let size = metadata.size
      // You can also access to download URL after upload.
      riversRef.downloadURL { (url, error) in
        guard let downloadURL = url else {
          // Uh-oh, an error occurred!
          return
        }
      }
    }
}

// https://firebase.google.com/docs/firestore/query-data/get-data?hl=es&authuser=0
