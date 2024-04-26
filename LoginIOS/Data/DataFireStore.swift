//
//  DataFireStore.swift
//  LoginIOS
//
//  Created by Mañanas on 23/4/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage




// Instanciar de Cloud Firestore
// FirebaseApp.configure()

let db = Firestore.firestore()

let coleccion="usuarios"



struct Usuario: Codable {
    var usuario:String
    var nombre:String
    var apellidos:String
    var imagenPerfil:String
    
    init(idUser:String){
        usuario=idUser
        nombre=""
        apellidos=""
        imagenPerfil=""
    }
}

// Para crear o sobrescribir un solo documento, utilice los siguientes métodos set() específicos del idioma:
//
func saveData(doc:String,user:Usuario) {
    
    Task{
        do {
            try await db.collection(coleccion).document(doc).setData(from: user)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
}

func readData(doc:String) async->Usuario? {
    
    let docRef = db.collection(coleccion).document(doc)
    var usuario:Usuario?=nil
    do {
        let document = try await docRef.getDocument()
        if document.exists {
            usuario = try document.data(as:Usuario.self)
            print("Cargado data: \(usuario?.nombre)")
        } else {
            print("Document does not exist")
        }
    } catch {
        print("Error getting document: \(error)")
    }
    return usuario
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

func subirArchivo(image:UIImage, user:Usuario)async->String {
    var urlString:String=""
    //Obtenga una referencia al servicio Cloud Storage mediante la aplicación Firebase predeterminada
    let storage = Storage.storage()
    // Get a non-default Cloud Storage bucket
    // storage = Storage.storage(url:"gs://my-custom-bucket")
    
    // Inicializción de referencias.
    // Create a root reference
    let storageRef = storage.reference()

    // Create a reference to "mountains.jpg"
    let route="\(user.usuario)/imageProfile.jpg"
    let imageProfileRef = storageRef.child(route)

    // Create a reference to 'mountains.jpg'
    // let mountainImagesRef = storageRef.child("mountains.jpg")
    // While the file names are the same, the references point to different files
    // mountainsRef.name == mountainImagesRef.name            // true
    // mountainsRef.fullPath == mountainImagesRef.fullPath    // false
    // File located on disk
    // let localFile = URL(string: pathToImage)
    // Create a reference to the file you want to upload
    // let riversRef = storageRef.child("images/rivers.jpg")

    // Upload the file to the path "images/rivers.jpg"
    let uploadTask = imageProfileRef.putData( image.jpegData(compressionQuality: 0.7)!) { metadata, error in
        guard let metadata = metadata else {
            print ("Error subiendo la imagen")
            return
        }
    }
        // Metadata contains file metadata such as size, content-type.
        //let size = metadata.size
        // You can also access to download URL after upload
        
    do {try await urlString=imageProfileRef.downloadURL().absoluteString}
    catch {
        print ("error recuperando URL")
    }

    return urlString
}

    
// https://firebase.google.com/docs/firestore/query-data/get-data?hl=es&authuser=0
