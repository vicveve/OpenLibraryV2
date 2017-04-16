//
//  BuscadorViewController.swift
//  OpenLibrary
//
//  Created by Victor Ernesto Velasco Esquivel on 14/04/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit

class BuscadorViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var txtAutores: UITextView!
    @IBOutlet weak var txtPortada: UITextView!
    @IBOutlet weak var txtTitulo: UILabel!
   
   
    @IBOutlet weak var ImagenSmall: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPortada.isEditable = false
        txtAutores.isEditable = false
        // Do any additional setup after loading the view.
        self.txtISBN.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        ImagenSmall.isHidden = true
        
       
    }
    
  
    
    
    @IBAction func eventoView(_ sender: Any) {
    }
    
    
    @IBAction func buscar(_ sender: Any) {
        ImagenSmall.isHidden = true
        txtPortada.isHidden = false
        buscarLibro()
    }
    
    func buscarLibro(){
        let cli = RestCliente()
        
        if (cli.isInternetAvailable())
        {
            let response = cli.buscarLibroFormateado(codigo: txtISBN.text!)
            if (response.RecuperaTitulo() != "")
            {
                txtTitulo.text = response.RecuperaTitulo()
            }
            if (response.RecuperaAutores() != "")
            {
               
                txtAutores.text = response.RecuperaAutores()
            }
            if (response.RecuperaPortada() != "")
            {
                /*lblPortada.lineBreakMode = NSLineBreakMode.byWordWrapping
                lblPortada.numberOfLines = response.portadaList.count * 2
                lblPortada.text = response.RecuperaPortada()
                let btn: UIButton = UIButton(frame: CGRect(x: 5, y: 5, width: 250, height: 40))
                //let btn: UIButton = UIButton(frame: CG)
                btn.backgroundColor = UIColor.white
                btn.setTitle(response.portadaList[0], for: .normal)
                btn.titleLabel?.textColor = UIColor.blue
                btn.setTitleColor(UIColor.blue, for: .normal)
                btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                btn.tag = 1
                self.contenedor.addSubview(btn)*/
                txtPortada.text = response.RecuperaPortada()
                let urlImageDown = NSURL(string: response.portadaList[0] )
                downloadImage(url: urlImageDown as! URL)
                txtPortada.isHidden = true
                ImagenSmall.isHidden = false
            }
            else{
                /*lblPortada.text = "No se encontraron portadas"*/
                txtPortada.isHidden = false
                txtPortada.text = "Sin portada"
            }
        }
        else{
            
            
            alerta(mensaje: "Verifique su conexiòn a la Red", titulo: "Alerta")
        }
        
        
        
        
    }
    
   /* func buttonAction(sender: UIButton!) {
        var btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            //do anything here
        }
    }*/
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.ImagenSmall.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    func alerta(mensaje : String, titulo: String){
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtISBN.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textFiel : UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
   /* func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
