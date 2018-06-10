//
//  MeasureChooseViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 11.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class MeasureChooseViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet var measureButtons: [MuscleButton]!
    
    @IBOutlet var mIcons: [UIImageView]!
    @IBOutlet weak var photoImageView: UIImageView!
    var selectedMeasure: [MeasureType] = []
    
    var complitionHandler: (([RootEvent]) -> ())!
    var selectedPosObjects = [RootEvent]()
    var posObjects = [RootEvent]()
    var selectedPoso: RootEvent!
    
    var pickerController = UIImagePickerController()
    //var assetsLibrary = ALAssetsLibrary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = mIcons.map{self.make(isRounded: true, imageView: $0)}
        
        _ = measureButtons.map{$0.addTarget(self, action: #selector(addMeasure(_:)), for: .touchUpInside)}

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        // Do any additional setup after loading the view.
        
        _ = measureButtons.map {self.setMeasureFor(sender: $0)}
        
    }

    
    @objc func back(sender: UIBarButtonItem) {
        complitionHandler(selectedPosObjects)
        _ = navigationController?.popViewController(animated: true)
    }
    func make(isRounded: Bool, imageView: UIImageView) {
        if isRounded {
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }else{
            imageView.layer.cornerRadius = imageView.frame.size.width / 15
            imageView.layer.borderWidth = 0//1
            imageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addMeasure(_ sender: MuscleButton){
        
        if let mes = (selectedPosObjects.filter{($0 as! Measure).measureType!.rawValue == sender.imageName}).first {
            
            sender.setImage(UIImage(named: "Add"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
            if (mes as! Measure).measureType == .photo {
                //chooseMediaAction(sender: sender)
                //photoImageView.image = UIImage(named: (mes as! Measure).measureType!.typeImageName)
                deletePhotoFrom(sender: sender)
                return
            }else{
                sender.setTitle((mes as! Measure).measureType!.caption, for: .normal)
            }
            
            selectedPosObjects.remove(at: selectedPosObjects.index(of: mes)!)
        }else{
            //selectedMeasure.append(MeasureType(rawValue: sender.imageName)!)
            let measure = MeasureType(rawValue: sender.imageName)!
            
            
            if measure == .photo {
                
                
                chooseMediaAction(sender: sender)
                
                //choosePhoto
                
            }else{
                
                callSmartAlert(measureType: measure) { val in
                    sender.setImage(UIImage(named: "Remove"), for: .normal)
                    sender.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    sender.setTitle(val.formatToHumanReadableForm() + "" + measure.unit, for: .normal)
                    self.selectedPosObjects.append(Measure(value: val, measureType: measure))
                }
                
                //alert
                
            }
            
        }
    }
    
    func setMeasureFor(sender: MuscleButton) {
        
        for i: Measure in (selectedPosObjects as! [Measure]) {
            
            if i.measureType!.rawValue == sender.imageName {
                if i.measureType! == .photo {
                    photoImageView.image = i.photoImage!
                    make(isRounded: false, imageView: self.photoImageView)
                }else {
                    sender.setTitle(i.value.formatToHumanReadableForm() + "" + i.measureType!.unit, for: .normal)
                }
                sender.setImage(UIImage(named: "Remove"), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                break
            }
        }
        
    }
    
    func callSmartAlert(measureType: MeasureType, updateAction: @escaping (Double)->()){
        let ac = SmartAlertController(title: "Сколько \(measureType.unit)", message: "\(measureType.caption)?", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?.first?.keyboardType = .decimalPad
        ac.textFields?.first?.keyboardAppearance = .alert
        var value = 0.0
        ac.smartField.updatedHandler = { t in
            value = Double(t)!
            if let selectedRange = ac.textFields?.first?.selectedTextRange {
                let cursorPosition = ac.textFields?.first?.offset(from: (ac.textFields?.first?.beginningOfDocument)!, to: selectedRange.start)
                print("\(cursorPosition)")
                let locale = NSLocale.autoupdatingCurrent
                let separator = locale.decimalSeparator
                let text = t.replacingOccurrences(of: ".", with: separator!)
                ac.textFields?.first?.text = text
                let add = (ac.textFields?.first?.text?.count)! < t.count ? 0 : 1
                if let newPosition = ac.textFields?.first?.position(from: (ac.textFields?.first?.beginningOfDocument)!, offset: cursorPosition! + add) {
                    ac.textFields?.first?.selectedTextRange = ac.textFields?.first?.textRange(from: newPosition, to: newPosition)
                }
            }
            print( "t : \(t)")
        }
        ac.smartField.type = .numeric
        ac.textFields?.first?.delegate = ac
        let submitAction = UIAlertAction(title: "Добавить", style: .default) { [unowned ac, self] _ in
            updateAction(value)
            //self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            // do something interesting with "answer" here
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MeasureChooseViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func chooseMediaAction(sender: MuscleButton)
    {
        let alert = UIAlertController(title: "Выбрать действия", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
            self.openGallary()
        }))
        
//        alert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { _ in
//           self.deletePhotoFrom(sender: sender)
//        }))
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: {_ in
            
        }))
        
        pickerController.delegate = self
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            pickerController.sourceType = .camera
            pickerController.mediaTypes = [kUTTypeImage as String] //[kUTTypeMovie as String, kUTTypeImage as String]
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Ошибка!", message: "Камера недоступна.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = [kUTTypeImage as String] //[kUTTypeMovie as String, kUTTypeImage as String]
        pickerController.allowsEditing = true
        pickerController.videoMaximumDuration = 30.0
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func deletePhotoFrom(sender: MuscleButton)
    {
        let measure = selectedPosObjects.filter{($0 as! Measure).measureType!.typeImageName == sender.imageName}.first!
        sender.setImage(UIImage(named: "Add"), for: .normal)
        sender.setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
        photoImageView.image = UIImage(named: (measure as! Measure).measureType!.typeImageName)
        selectedPosObjects.remove(at: selectedPosObjects.index(of: measure)!)
        make(isRounded: true, imageView: photoImageView)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject
        
        //        if let type:AnyObject = mediaType {
        //            if type is String {
        //                let stringType = type as! String
        //                if stringType == kUTTypeMovie as! String {
        //                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
        //                    if let url = urlOfVideo {
        //                        // 2
        //                        assetsLibrary.writeVideoAtPathToSavedPhotosAlbum(url as URL!,
        //                                                                         completionBlock: {(url: NSURL!, error: NSError!) in
        //                                                                            if let theError = error{
        //                                                                                println("Error saving video = \(theError)")
        //                                                                            }
        //                                                                            else {
        //                                                                                println("no errors happened")
        //                                                                            }
        //                        })
        //                    }
        //                }
        //
        //            }
        //        }
        picker.dismiss(animated: true, completion: nil)
        //You will get cropped image here..
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            photoImageView.image = image
            self.selectedPosObjects.append(Measure(value: 0, measureType: .photo, photo: image))
            let sender = measureButtons.filter{$0.imageName == "phototake"}.first!
            sender.setImage(UIImage(named: "Remove"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.make(isRounded: false, imageView: self.photoImageView)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
