//
//  LoadImageDelegate.swift
//  LoginIOS
//
//  Created by Mañanas on 25/4/24.
//

import UIKit

extension UIImageView {
    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            // Manejar el caso de URL inválida
            print("URL inválida: \(urlString)")
            return
        }
        
        // Utiliza una tarea asincrónica para cargar la imagen
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } catch {
                // Manejar el error en la carga de la imagen
                print("Error al cargar la imagen: \(error)")
            }
        }
    }

    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}
