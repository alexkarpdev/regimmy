//
//  MuscleChooseViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 11.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class MuscleChooseViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var muscleButtons: [UIButton]!
    
    @IBOutlet weak var csViewWidth: NSLayoutConstraint!
    @IBOutlet weak var csViewHeight: NSLayoutConstraint!
    @IBOutlet weak var csView: UIView!
    @IBOutlet weak var musclePartsImageView: UIImageView!
    @IBOutlet weak var muscleMainImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        
        
        csViewHeight.constant = self.view.frame.size.height - 140
        csViewWidth.constant = self.view.frame.size.width * 2
        
        csView.layoutIfNeeded()
        csView.layoutSubviews()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnScrollAction))
        swipeRight.direction = .right
        scrollView.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeOnScrollAction))
        swipeRight.direction = .left
        scrollView.addGestureRecognizer(swipeLeft)
        scrollView.isUserInteractionEnabled = true
        
        muscleButtons.map{$0.addTarget(self, action: #selector(selectMuscle(_:)), for: .touchUpInside)}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func swipeOnScrollAction(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            var index = segmentedControl.selectedSegmentIndex
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                index -= 1
            case UISwipeGestureRecognizerDirection.left:
                index += 1
            default:
                break
            }
            
            if index >= 0 && index <= 2 {
                segmentedControl.selectedSegmentIndex = index
                changeViewOn(segmentedControl.selectedSegmentIndex)
            }
            
            
            
        }
    }
    
    @IBAction func selectMuscle(_ sender: MuscleButton){
        muscleButtons.map{$0.setImage(UIImage(named: "unchecked"), for: .normal)}
        sender.setImage(UIImage(named: "checked"), for: .normal)
        
        if let muscleImage = UIImage(named: sender.imageName) {
            musclePartsImageView.alpha = 0
            musclePartsImageView.image = muscleImage
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: ({
                self.musclePartsImageView.alpha = 1
                }), completion: nil)
        }
        
    }
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        
        changeViewOn(sender.selectedSegmentIndex)
        
    }
    
    func changeViewOn(_ index: Int){
        switch index {
        case 0:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 1:
            scrollView.setContentOffset(CGPoint(x: (scrollView.contentSize.width - scrollView.frame.size.width) / 2, y: 0), animated: true)
        case 2:
            scrollView.setContentOffset(CGPoint(x: (scrollView.contentSize.width - scrollView.frame.size.width), y: 0), animated: true)
        default:
            break
        }
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
