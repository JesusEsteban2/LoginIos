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

let coleccionUsuarios="usuarios"
let coleccionDialogos="dialogos"


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
    
    // Para crear o sobrescribir un solo documento, utilice los siguientes métodos set() específicos del idioma:
    //

    

}

struct Dialog:Codable {
    var dialogId:String
    var titulo:String
    var usuarios:[String]
    var conversacion:String
}

struct Mensaje:Codable {
    var mensajeId:String
    var fecha:Date
    var remitente:String
    var texto:String
}





func delData(doc:String) {
    
    Task {
        do {
            try await db.collection(coleccionUsuarios).document(doc).delete()
            print("Document successfully removed!")
        } catch {
            print("Error removing document: \(error)")
        }
    }
}

func readDialog(doc:String) async->Dialog? {
    
    let docRef = db.collection(coleccionDialogos).document(doc)
    var dialog:Dialog?=nil
    do {
        let document = try await docRef.getDocument()
        if document.exists {
            dialog = try document.data(as:Dialog.self)
            print("Cargado data: \(dialog?.titulo)")
        } else {
            print("Document does not exist")
        }
    } catch {
        print("Error getting document: \(error)")
    }
    return dialog
}

func buscarDialog(userId:String) async->Dialog? {
     
    do {let dialogos = try await db.collection(coleccionDialogos).whereField(userId, in:["usuarios"]).getDocuments()
        print ("Se ha encontrado conversación: \(dialogos.count)")
        for dialog in dialogos.documents {
            
            print ("encontrado conversacion: \(dialog)")
        }
        // let docRef = db.collection(coleccionDialogos).document(dialogos[0])
    }
    catch {
        
    }
    /**
    var dialog:Dialog?=nil
    do {
        let document = try await docRef.getDocument()
        if document.exists {
            dialog = try document.data(as:Dialog.self)
            print("Cargado data: \(dialog?.titulo)")
        } else {
            print("Document does not exist")
        }
    } catch {
        print("Error getting document: \(error)")
    }
     */
    return nil
}

func readUser(doc:String) async->Usuario? {
    
    let docRef = db.collection(coleccionUsuarios).document(doc)
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

func saveUser(doc:String,user:Usuario) {
    
    Task{
        do {
            try await db.collection(coleccionUsuarios).document(doc).setData(from: user)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
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

func redondearImagen (imagen:UIImageView)-> UIImageView{
    
    imagen.layer.borderWidth=1.0
    imagen.layer.masksToBounds = false
    imagen.layer.borderColor = UIColor.black.cgColor
    imagen.layer.cornerRadius = imagen.frame.size.height/2
    imagen.clipsToBounds = true
    
    return imagen
}
    
// https://firebase.google.com/docs/firestore/query-data/get-data?hl=es&authuser=0
