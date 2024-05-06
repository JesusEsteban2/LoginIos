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

enum Errores: Error {
    case errorRecuperandoURL (urlString:String)
    case errorSubiendoImagen (urlString:String)
    case noSePuedeConvertir
    case noSePuedeAccederFireBase
}

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

func readMensajes(doc:String,conve:String) async throws ->[Mensaje] {
    
    var mensajes:[Mensaje]=[]
    
        let text="/"+coleccionDialogos+"/"+doc+"/"+conve
        // "/dialogos/aaDWdoAso7Q16mh5dOhV/8OkuNKNp2nyJL8zRJoKk"
        do {
            let docRef = try await db.collection(text).getDocuments()
            // Expresión alternativa
            //db.collection(coleccionDialogos).document(doc).collection(text).getDocuments()
            
            print ("Mensajes para: \(text)")
            print ("Numero de doc: \(docRef.count)")
            
            for doc in docRef.documents {
                let mensaje = try doc.data(as: Mensaje.self)
                print ("Encontrado Mensaje: \(mensaje.texto)")
                mensajes.append(mensaje)
            }
        }
    
    return mensajes
}

/**
 Buscar conversaciones para un id de usuario
 */
func buscarDialog(userId:String) async throws -> [Dialog] {
    var dialogos:[Dialog]=[]
    
    // Recuperar conversaciones para el Id de usuario.
    let querySnapshot = try await db.collection(coleccionDialogos).whereField("usuarios", arrayContains: userId).getDocuments()
    
    // para cada conversacion crear un dialogo y añadir al array a retornar.
    for document in querySnapshot.documents {
        do {
            let dialogo=try document.data(as: Dialog.self)
            dialogos.append(dialogo)
        }
        catch{
            throw Errores.noSePuedeAccederFireBase
        }
    }

    return dialogos
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

func subirArchivo(image:UIImage, user:Usuario) async throws ->String {
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
            print ("Error subiendo archivo")
            return
        }
    }
        // Metadata contains file metadata such as size, content-type.
        //let size = metadata.size
        // You can also access to download URL after upload
        
    do {try await urlString=imageProfileRef.downloadURL().absoluteString}
    catch {
        throw Errores.errorRecuperandoURL(urlString: urlString)
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
