//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Bera on 22.11.2019.
//  Copyright © 2019 Bera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getRatesClicked(_ sender: Any) {
        //Adımlar
        // 1) Request & Session
        // 2) Response & Data
        // 3) Parsing & JSON Serialization
        
        //İstek alacağımız url'i belirtiyoruz. Dikkat edilmesi gereken kısım https uzantısı varsa info.plist'ten ayarlama gerekiyor.
        //Ayarlama App Transport Security Setting ekleyip onun altında Allow arbitrary loads'u yes yapmamız gerekiyor. Böylece https uzantılara izin veriyoruz.
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=e0ab4a5d134c9cef8825835e09a52ce8")
        //İstek almaya hazırlıyoruz.
        let session = URLSession.shared
        //İstek alırken gerçekleşecek olayları belirtiyoruz.
        let task = session.dataTask(with: url!) { (data, response, error) in
            //İstekte herhangi bir hata oldu mu kontrolü yapıyoruz.
            if error != nil{
                //Hata olduğu takdirde kullanıcıya alert veriyoruz.
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                //Veri var mı yok mu kontrolü yapıyoruz.
                if data != nil{
                    //Verileri çekmek için kullandığımız fonksiyon bize bir throws fırlattığından dolayı daima try catch içine almamız gerekiyor.
                    do{
                        //İstek attığımız URL'den dönen data'yı JSONSerialization.jsonObject fonksiyonu ile işlenebilir hale getiriyoruz.
                        //Oluşturduğumuz jsonResponse objesini Dictionary String ve Any olarak CAST ediyoruz. Bunun sebebi çektiğimiz veri bize key-value olarak geldiği için ilk değer
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        //Bu işlemlerin hepsi arka planda bir thread oluşturduğu için bizim yazdırma ve/veya herhangi bir işlemimizi main thread içinde async şekilde yapmamız gerekiyor. Yapmadığımız takdirde uygulama kilitlenebiliyor.
                        DispatchQueue.main.async {
                            //Çekeceğimiz değer yine bir key-value değerine sahip olduğundan dolayı [String : Any] tipi olarak CAST ediyoruz.
                            if let rates = jsonResponse["rates"] as? [String : Any]{
                                //Çektiğimiz verinin value değeri ne ise ona CAST etme işlemi yapıyoruz ve artık değerleri işleyebiliriz.
                                if let cad = rates["CAD"] as? Double{
                                    self.cadLabel.text = "CAD : \(cad)"
                                }
                                if let chf = rates["CHF"] as? Double{
                                    self.chfLabel.text = "CHF : \(chf)"
                                }
                                if let gbp = rates["GBP"] as? Double{
                                    self.gbpLabel.text = "GBP : \(gbp)"
                                }
                                if let jpy = rates["JPY"] as? Double{
                                    self.jpyLabel.text = "JPY : \(jpy)"
                                }
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD : \(usd)"
                                }
                                if let turkish = rates["TRY"] as? Double{
                                    self.tryLabel.text = "TRY : \(turkish)"
                                }
                            }
                        }
                    }
                    catch{
                        print("Error")
                    }
                }
            }
        }
        //İstek başlatmak için kullanıyoruz. (!) Kesinlikle yazmak gerekiyor yoksa işlem başlamıyor.
        task.resume()
    }
    
}

