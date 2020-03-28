//
//  ViewController.swift
//  quicktouch
//
//  Created by nuri Lee on 11/01/2020.
//  Copyright © 2020 nuri Lee. All rights reserved.
// 광고 애드몹 id : ca-app-pub-8919920204791449~5712667897

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //라이트모드
        overrideUserInterfaceStyle = .light
        
        
        
        

        
        
        //글로벌 값 저장
        UserDefaults.standard.set(false, forKey: "gameBoolGlobal");
        
        //글로벌 값 저장 game_count_down
        UserDefaults.standard.set(self.game_count_down_value, forKey: "game_count_down");

        
        
        
        //status bar 켜주기 옵저버
        let name = Notification.Name("statusBarOn");
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarOn), name: name, object: nil)
        
        
        
        
        //배경 그라데이션
        var background : CALayer ;

        background = CAGradientLayer().turquoiseColorTouchKing()

        
        //큰곳으로 기준잡기
        var bg_size = CGFloat();
        if self.view.frame.width <= self.view.frame.height{
            bg_size = self.view.frame.height;
        }else{
            bg_size = self.view.frame.width;
        }
        background.frame = CGRect(x: 0, y: 0, width: bg_size, height: bg_size)
        
        background.name = "gradation_back";
        
        
        //뷰에 등록된 레이어들 삭제하기
        for layer in self.view.layer.sublayers! {
            if layer.name == "gradation_back" {
                 layer.removeFromSuperlayer()
            }
        }
        
        self.view.layer.insertSublayer(background, at: 0)
        
        
        
        
    }
    
    
    @objc func statusBarOn(){
        //status bar 가리기
        DispatchQueue.main.async() {
            self.statusBarShouldBeHidden = false;
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    //status바 숨기기
    var statusBarShouldBeHidden = false;
        override var prefersStatusBarHidden: Bool {
            return statusBarShouldBeHidden
        }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
       
        
    }
    
    
    
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnMulti: UIButton!
    
    
    //멀티플레이 버튼 클릭
    @IBAction func btnMultiPress(_ sender: Any) {
        
        DispatchQueue.main.async() {
            
            //시작버튼 절대 좌표값
            let multiButtonViewPoint = self.btnMulti.superview?.convert(self.btnMulti.frame.origin, to: self.view);
            //버튼 크기
            let btnMulti_width_size = self.btnMulti.bounds.size.width;
            let btnMulti_height_size = self.btnMulti.bounds.size.height;
            //트랜지션 애니메이션 열릴 좌표 구하기
            let btn_trasition_point_x = multiButtonViewPoint!.x + btnMulti_width_size/2;
            let btn_trasition_point_y = multiButtonViewPoint!.y + btnMulti_height_size/2;
            self.startTransPoint = CGPoint(x: btn_trasition_point_x, y: btn_trasition_point_y)
            
        
        
        
            //글로벌 값 불러오기
            let game_count_down = UserDefaults.standard.object(forKey: "game_count_down") as! Int;
            
            if( game_count_down > 0 )
            {
                let temp_val = game_count_down - 1;
                print("남은 카운트 다운 : ", terminator:"");
                print(temp_val);
                
                //글로벌 값 저장 game_count_down
                UserDefaults.standard.set(temp_val, forKey: "game_count_down");
                
                
                //status bar 가리기
                DispatchQueue.main.async() {
                    self.statusBarShouldBeHidden = true;
                    self.setNeedsStatusBarAppearanceUpdate()
                }
                self.performSegue(withIdentifier: "toMulti", sender: self);
                
            }else{
                print("광고 실행");
                
                //글로벌 값 저장 game_count_down
                UserDefaults.standard.set(3, forKey: "game_count_down")
                
                //광고 실행시 이 부분 변경
                //status bar 가리기
                DispatchQueue.main.async() {
                    self.statusBarShouldBeHidden = true;
                    self.setNeedsStatusBarAppearanceUpdate()
                }
                self.performSegue(withIdentifier: "toMulti", sender: self);
                
            }
        
        }//sync
        
    }
    
    
    //시작 버튼 클릭
    @IBAction func btnStartPress(_ sender: UIButton) {
        
        
        DispatchQueue.main.async() {
            
            //시작버튼 절대 좌표값
            let startButtonViewPoint = self.btnStart.superview?.convert(self.btnStart.frame.origin, to: self.view);
            //버튼 크기
            let btnStart_width_size = self.btnStart.bounds.size.width;
            let btnStart_height_size = self.btnStart.bounds.size.height;
            //트랜지션 애니메이션 열릴 좌표 구하기
            let btn_trasition_point_x = startButtonViewPoint!.x + btnStart_width_size/2;
            let btn_trasition_point_y = startButtonViewPoint!.y + btnStart_height_size/2;
            self.startTransPoint = CGPoint(x: btn_trasition_point_x, y: btn_trasition_point_y)
            
        
        
        
            //글로벌 값 불러오기
            let game_count_down = UserDefaults.standard.object(forKey: "game_count_down") as! Int;
            
            if( game_count_down > 0 )
            {
                let temp_val = game_count_down - 1;
                print("남은 카운트 다운 : ", terminator:"");
                print(temp_val);
                
                //글로벌 값 저장 game_count_down
                UserDefaults.standard.set(temp_val, forKey: "game_count_down");
                
                
                //status bar 가리기
                DispatchQueue.main.async() {
                    self.statusBarShouldBeHidden = true;
                    self.setNeedsStatusBarAppearanceUpdate()
                }
                self.performSegue(withIdentifier: "toStart", sender: self);
                
            }else{
                print("광고 실행");
                
                //글로벌 값 저장 game_count_down
                UserDefaults.standard.set(3, forKey: "game_count_down")
                
                //광고 실행시 이 부분 변경
                //status bar 가리기
                DispatchQueue.main.async() {
                    self.statusBarShouldBeHidden = true;
                    self.setNeedsStatusBarAppearanceUpdate()
                }
                self.performSegue(withIdentifier: "toStart", sender: self);
                
            }
        
        }//sync
        
        
        
    }
    
    let transition = CircularTransition();
    
    var startTransPoint : CGPoint!;
       
    //게임 광고 카운트 다운
    var game_count_down_value : Int = 3;
    
    
   //화면 전환 함수
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
       if segue.identifier == "toStart" {
        let secondVC = segue.destination as! ViewGameController
           secondVC.transitioningDelegate = self as UIViewControllerTransitioningDelegate
           secondVC.modalPresentationStyle = .custom
        
       }else if segue.identifier == "toMulti" {
        let secondVC = segue.destination as! ViewMultiController
           secondVC.transitioningDelegate = self as UIViewControllerTransitioningDelegate
           secondVC.modalPresentationStyle = .custom
        
       }
    
    
       
   }
       
       
    
    //애니메이션 화면전환
   func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
       transition.transitionMode = .present;
       transition.startingPoint = startTransPoint;
       
       


        transition.circleColor = UIColor.black;
    
        
  
         
       
//       //다크모드 체크
//       if #available(iOS 12.0, *) { //12버전 이상일때
//           if self.traitCollection.userInterfaceStyle == .dark {
//               // User Interface is Dark
//               transition.circleColor = UIColor(red: 28 / 255.0, green: 28 / 255.0, blue: 30 / 255.0, alpha: 1.0);
//           } else {
//               // User Interface is Light
//               transition.circleColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0);
//           }
//       } else {
//           // Fallback on earlier versions
//           transition.circleColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0);
//       }
       
     
       
       return transition
   }
   
   func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       transition.transitionMode = .dismiss
       transition.startingPoint = startTransPoint;
       
       
    transition.circleColor = UIColor.systemBackground;
       
//
//       //다크모드 체크
//       if #available(iOS 12.0, *) {
//           if self.traitCollection.userInterfaceStyle == .dark {
//               // User Interface is Dark
//               transition.circleColor = UIColor(red: 28 / 255.0, green: 28 / 255.0, blue: 30 / 255.0, alpha: 1.0);
//           } else {
//               // User Interface is Light
//               transition.circleColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0);
//           }
//       } else {
//           // Fallback on earlier versions
//       }
//
       return transition
       
   }

}

