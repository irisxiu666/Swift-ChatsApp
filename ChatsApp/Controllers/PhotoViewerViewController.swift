//
//  PhotoViewerViewController.swift
//  ChatsApp
//
//  Created by Rick on 12/17/22.
//

import UIKit
import SDWebImage

class PhotoViewerViewController: UIViewController {
    
    private let url : URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

   

}
