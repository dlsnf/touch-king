//
//  ViewGameController.swift
//  quicktouch
//
//  Created by nuri Lee on 11/01/2020.
//  Copyright © 2020 nuri Lee. All rights reserved.
//

import UIKit

class ViewGameController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //라이트모드
        overrideUserInterfaceStyle = .light
        
        
        gameStartInit();
        
        
        
        //화면 탭
        let tapGeustureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTap(recognizer:)))
        tapGeustureRecognizer.numberOfTapsRequired = 1;
        self.view.isUserInteractionEnabled = true;
        self.view.addGestureRecognizer(tapGeustureRecognizer);
        
        //레드볼 탭
        let tapGeustureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.viewTap2(recognizer:)))
        tapGeustureRecognizer2.numberOfTapsRequired = 1;
        self.redBall.isUserInteractionEnabled = true;
        self.redBall.addGestureRecognizer(tapGeustureRecognizer2);
        
        
        
    }
    
    
    //화면 탭했을때
       @objc func viewTap2(recognizer : UITapGestureRecognizer){
           //print("tap");
           //let point = recognizer.location(in: view);
           //print(point);
        
            //레드볼 눌렀을때 함수 실행
            redBallTouch();
        }
    

    //화면 탭했을때
    @objc func viewTap(recognizer : UITapGestureRecognizer){
        //print("tap");
        //let point = recognizer.location(in: view);
        //print(point);
        
        //print("실패");
        
        //진동 에러
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        

        //화면 뒷배경 컬러로 경고주기
        DispatchQueue.main.async() {
            
            self.view.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping:2,
                           initialSpringVelocity:0,
                           options: .curveEaseInOut,
                           animations: {
                            self.view.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                            
                            
            }, completion: { (finished) -> Void in
                //print("end");
                
            })
        }
        
        
        timer.invalidate();
        gameStartTimer.invalidate();
        
        //글로벌 값 저장
        UserDefaults.standard.set(false, forKey: "gameBoolGlobal");
        
        //alert 뛰우기
        let alertController = UIAlertController(title: NSLocalizedString("fail", comment: ""), message: NSLocalizedString("dark_press", comment: ""), preferredStyle: .alert)
         
         let okButton = UIAlertAction(title: NSLocalizedString("home", comment: ""), style: .default, handler: { (action) -> Void in
             //print("Ok button tapped")
            
            //status bar 키기 옵저버 포스트 날리기
            let noti = Notification.init(name : Notification.Name(rawValue: "statusBarOn"));
            NotificationCenter.default.post(noti);
            
            self.presentingViewController?.dismiss(animated: true);
         })
        
        let replayButton = UIAlertAction(title: NSLocalizedString("replay", comment: ""), style: .default, handler: { (action) -> Void in
            //print("Ok button tapped")

            //글로벌 값 불러오기
            let game_count_down = UserDefaults.standard.object(forKey: "game_count_down") as! Int;
            
            if( game_count_down > 0 )
            {
                let temp_val = game_count_down - 1;
                print("남은 카운트 다운 : ", terminator:"");
                print(temp_val);
                
                //글로벌 값 저장 game_count_down
                UserDefaults.standard.set(temp_val, forKey: "game_count_down");
                
                self.gameStartInit();
            }else{
                print("광고 실행");
                
                //글로벌 값 저장 game_count_down
                UserDefaults.standard.set(3, forKey: "game_count_down")
                
                
                //광고 실행시 이 부분 변경
                self.gameStartInit();
                
            }
            
        })
        
        alertController.addAction(okButton);
        alertController.addAction(replayButton);
        self.present(alertController, animated: true, completion: nil)
        

    
    }
    
    

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        print("창 종료");
        
        timer.invalidate();
        gameStartTimer.invalidate();
    }
    
    @IBOutlet weak var nabbuImage: UIImageView!
    @IBOutlet weak var redBall: Dot!
    @IBOutlet weak var redBallLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    //시간측정 타이머
    var timer = Timer();
    var duration : Float = 0;
    
    var timerView = Timer();
    
    
    //게임 시작 타이머
    var gameStartTimer = Timer();
    var gameStartDuration : Float = 0;
    
    //나뿌 타이머
    var timer_nabbu = Timer();
    var nabbuBool : Bool = false;
    
    //게임 시작되는 시간
    var gameStartTime : Float = 0;
    
    //게임 시작한건지 체크
    var gameEndBool : Bool = false;
    
    
    
    var param : Int?;
    
    @IBOutlet weak var timeCountLabel: UILabel!
    
    //레드볼 관련 변수들
    var redBallCount : Float = 20; //레드볼 갯수
    var gameCount : Float = 0; //게임 처음 시작 카운트
    var redBallMinDistance : Float = 150; //레드볼 최소 간격
    var redBallPositionArray : [[Float]] = Array() ; //좌표 배열
    var redBallWidth = Float(); //레드볼 가로크기
    var redBallHeight = Float(); //레드볼 세로크기
    
    var redBallScaleVal = Float(); //레드볼 스케일 변수값
    var redBallScaleDistance : Float = 0.03; //크기 줄어드는 값
    
    @IBOutlet weak var redBallTopPosition: NSLayoutConstraint!
    @IBOutlet weak var redBallLeftPosition: NSLayoutConstraint!
    
    var screenWidth = Float();
    var screenHeight = Float();
    

    
    func gameStartInit()
    {
        
        
        gameStartTime = 0;
        gameEndBool = false;
        duration = 0;
        gameStartDuration = 0;
        gameCount = redBallCount;
        redBallPositionArray = Array(repeating: Array(repeating: 0,count:2 ), count: Int(redBallCount));
        redBallScaleVal = 1;
        
        timeCountLabel.text = "0.0" + " " + NSLocalizedString("second", comment: "");
        
        
        //나뿌 돌리기
        self.timer_nabbu.invalidate();
        nabbu_start();
        
        
        self.nabbuImage.isHidden = false;
        
        self.redBall.isHidden = true;
        self.redBallLabel.text = String(format: "%.0f", redBallCount)
        
        self.view.isUserInteractionEnabled = true;
        self.redBall.isUserInteractionEnabled = true;
        
        
        DispatchQueue.main.async() {
            self.redBall.transform = CGAffineTransform(scaleX: CGFloat(self.redBallScaleVal), y: CGFloat(self.redBallScaleVal))
        }
        
        
        //1~3사이 랜덤 숫자
        let randomNum: UInt32 = arc4random_uniform(3) + 1;
        
        //게임 시작되는 시간
        gameStartTime = Float(randomNum) + 1;
        
        //글로벌 값 저장
        UserDefaults.standard.set(false, forKey: "gameBoolGlobal");
        
        
        self.view.backgroundColor = UIColor.black;
        infoLabel.text = NSLocalizedString("ready", comment: "");
        
        
        
        
        
        
       //레드볼 포지션 초기화
        redBallPositionInit();
        
        //게임 시작 타이머 가동
        gameTimerStart();
        
        print("게임 시작시간 : " + String(describing: gameStartTime) + "초 후");

    }
    
    
    //레드볼 포지션 초기화
    func redBallPositionInit()
    {
        
        //redBallPositionArray[0][0] = 400;
        //print(String(describing: redBallPositionArray[0][0]));
        
        
//        print("safe area position top bottom left right");
        
        //화면 safe area 좌표 구하기
        let window = UIApplication.shared.keyWindow
        let topPadding = Float((window?.safeAreaInsets.top ?? 0) + 4);
        let bottomPadding = Float((window?.safeAreaInsets.bottom ?? 0) + 4);
        let leftPadding = Float((window?.safeAreaInsets.left ?? 0) + 4);
        let rightPadding = Float((window?.safeAreaInsets.right ?? 0) + 4);
        
//        print(String(describing: topPadding));
//        print(String(describing: bottomPadding));
//        print(String(describing: leftPadding));
//        print(String(describing: rightPadding));
        
        
        //레드볼 크기
        redBallWidth = Float(redBall.frame.width);
        redBallHeight = Float(redBall.frame.height);
                
        //        print("red Ball width height");
//                print(String(describing: redBallWidth));
//                print(String(describing: redBallHeight));
        
        
        
        //스크린 사이즈
        let screenSize = UIScreen.main.bounds;
        screenWidth = Float(screenSize.width);
        screenHeight = Float(screenSize.height);
        
//        print(String(describing: screenWidth));
//        print(String(describing: screenHeight));
        
        
        
        //전 레드볼 좌표값
        var preBallPoint = CGPoint(x: CGFloat(redBallPositionArray[0][0]), y: CGFloat(redBallPositionArray[0][1]));
        
        
        //게임 수 만큼 반복
        var i : Int = 0;
        while(i < Int(redBallCount))
        {
            //print(i);
            
            
            
            
            
            //반복하면서 포지션 나올때까지 반복
            var newPoint_x : UInt32 = 0;
            var newPoint_y : UInt32 = 0;
            var checkBool = false;
            while(!checkBool)
            {
                //새롭게 생성될 좌표값
                newPoint_x = arc4random_uniform(UInt32(screenWidth)) + 0; //스크린 사이즈만큼 랜덤 생성
                newPoint_y = arc4random_uniform(UInt32(screenHeight)) + 0; //스크린 사이즈만큼 랜덤 생성
                let newBallPoint = CGPoint(x: CGFloat(newPoint_x), y: CGFloat(newPoint_y));
                
                //좌표 생성 가능한지 체크
                checkBool = randomPositionCheck(prePoint: preBallPoint, newPoint: newBallPoint, ballMinDistance : redBallMinDistance, ballWidth: redBallWidth, ballHeight: redBallHeight, topPadding: topPadding, bottomPadding: bottomPadding, leftPadding: leftPadding, rightPadding: rightPadding, screenWidth: screenWidth, screenHeight: screenHeight);
                
            }
            

            //checkBool이 트루이면 좌표값 입력
            if(checkBool)
            {
                //print("좌표 등록 성공!");
                redBallPositionArray[i][0] = Float(newPoint_x);
                redBallPositionArray[i][1] = Float(newPoint_y);
                
                
                //전 포인트 저장
                preBallPoint = CGPoint(x: CGFloat(redBallPositionArray[i][0]), y: CGFloat(redBallPositionArray[i][1]));
                
                
            }else{
                //print("좌표 등록 실패!");
            }

            
            
            i += 1;
        }//while
        
        
        //2차원 배열 프린트
        arrayPrint();
        
                
        
    }
    
    
    
    //2차원 배열 프린트
    func arrayPrint()
    {
        var i : Int = 0;
        while(i < Int(redBallCount)) //수정 변수 필요 - redBallCount
        {
            
            let temp = i + 1;
            print(temp, terminator:"");
            print("번째 좌표값 (", terminator:"")
            print( redBallPositionArray[i][0], terminator:"");
            print(", ", terminator:"")
            print( redBallPositionArray[i][1], terminator:"");
            print(")");
            
            i += 1;
        }
    }
    
    
    func randomPositionCheck(prePoint : CGPoint, newPoint : CGPoint, ballMinDistance : Float,  ballWidth:Float, ballHeight:Float, topPadding : Float, bottomPadding : Float, leftPadding : Float, rightPadding : Float, screenWidth:Float, screenHeight:Float) -> Bool
    {
        //prePoint값과 newPoint값이 size만큼보다 대각선 거리가 작고 safe area에 겹치면 false 반환
        
        var result = false;
        
        
        let prePoint_x : Float = Float(prePoint.x);
        let prePoint_y : Float = Float(prePoint.y);
        let newPoint_x : Float = Float(newPoint.x);
        let newPoint_y : Float = Float(newPoint.y);
        
        
//        print("랜덤 포지션 체크");
//        print("pre Point x - " + String(describing: prePoint_x));
//        print("pre Point y - " + String(describing: prePoint_y));
//        print("new Point x - " + String(describing: newPoint_x));
//        print("new Point x - " + String(describing: newPoint_y));
        
//        print("DD");
//        print(screenWidth);
//        print(screenHeight)
//        print(topPadding);
        
        
        
        //두 좌표값 차이 절대값
        let x3 = (newPoint_x - prePoint_x).magnitude;
        let y3 = (newPoint_y - prePoint_y).magnitude;

        //두 좌표 대각선 거리 sqrt 제곱근
        let preNewDistance = sqrt(x3*x3 + y3*y3)
        
//        print("대각선 거리 - ", terminator:"")
//        print(preNewDistance)
        
        
        
        
        
        //이전 레드볼과 거리 차이가 최소 거리보다 클 경우만
        if( preNewDistance >= redBallMinDistance)
        {
            //safe area에 겹치는지 체크
            //왼쪽 또는 오른쪽 겹치는지 체크
            if( newPoint_x >= leftPadding && (newPoint_x) <= (screenWidth - leftPadding - rightPadding - ballWidth))
            {
                
                //위쪽 또는 아래 겹치는지 체크
                if( newPoint_y >= topPadding && (newPoint_y) <= (screenHeight - topPadding - bottomPadding - ballHeight))
                {
                    if(newPoint_x >= 300)
                    {
                        print("왜걸림?");
                    }
                    
                    result = true;
                }
            }
        }
        
        
        
        
        //print("랜덤 포지션 체크 끝")
        
        //이전 레드불과 대각선거리 100이상 차이 나는지 체크
        
        //safe area에 겹치는지 체크
        
        
        return result;
    }

    
    func nabbu_start()
    {
        //게임스타트타이머 종료 및 초기화
        self.timer_nabbu.invalidate();
        
        timer_nabbu = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (Timer) in
            if(self.nabbuBool)
            {
                self.nabbuImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.nabbuBool = false;
            }else{
                self.nabbuImage.transform = CGAffineTransform(scaleX: -1, y: 1)
                self.nabbuBool = true;
            }
            
            //print("좌우반전?");
        })
    }
    
    func gameTimerStart()
    {
        
        //게임스타트타이머 종료 및 초기화
        self.gameStartTimer.invalidate();
        
        gameStartTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            self.gameStartDuration = self.gameStartDuration + 1;
            print(self.gameStartDuration);
            
            //게임 시작조건
            if( self.gameStartDuration >= self.gameStartTime)
            {
                //게임스타트타이머 종료
                self.gameStartTimer.invalidate();
                //print("게임 시작");
                self.gameEndBool = true;
                //글로벌 값 저장
                UserDefaults.standard.set(true, forKey: "gameBoolGlobal");
                //self.gameStart();
                self.gameStart2();
            }
        })
        
    }
    
    
    //게임 시작 2
    func gameStart2()
    {
        print("게임시작2");
        
        
        self.nabbuImage.isHidden = true;
        
        
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.111) {
        DispatchQueue.main.async() {
            
            //레드볼 화면 이동
            //self.redBall.frame.origin.x = CGFloat(self.redBallPositionArray[0][0]);
            //self.redBall.frame.origin.y = CGFloat(self.redBallPositionArray[0][1]);
            self.redBallLeftPosition.constant = CGFloat(self.redBallPositionArray[0][0]);
            self.redBallTopPosition.constant = CGFloat(self.redBallPositionArray[0][1]);
            
            self.redBall.isHidden = false;
            
        }
        
        
        
        DispatchQueue.main.async() {
            self.infoLabel.text = NSLocalizedString("go", comment: "");
        }
        
        
        
        timerStart();
        timerViewStart();
        
    }
    
    //레드볼 눌렀을때
    func redBallTouch()
    {
        
        //진동 강하게
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        
        //처음 눌렀을때
        if(gameCount == redBallCount)
        {
            DispatchQueue.main.async() {
                self.infoLabel.text = "";
            }
        }
        
        
        
        //눌러야할게 남았을때
        if( gameCount > 1 )
        {
            
           
            
            DispatchQueue.main.async() {
                
                let temp : Int = Int(self.gameCount - 1);
                
                DispatchQueue.main.async() {
                self.redBallLabel.text = String(describing: temp);
                    
                    DispatchQueue.main.async() {

                             //누를때마다 크기 작아지기
                             self.redBallScaleVal = self.redBallScaleVal - self.redBallScaleDistance;
                             self.redBall.transform = CGAffineTransform(scaleX: CGFloat(self.redBallScaleVal), y: CGFloat(self.redBallScaleVal))
                             
                         }

                        
                         DispatchQueue.main.async() {

                            //self.infoLabel.text = "";
                             
                            let temp : Int = Int(self.gameCount - 1);
                            //print(temp);
                             
                             
                            //레드볼 화면 이동
                            //self.redBall.frame.origin.x = CGFloat(self.redBallPositionArray[temp][0]);
                            //self.redBall.frame.origin.y = CGFloat(self.redBallPositionArray[temp][1]);
                            
                            
                            //레드볼 크기 //크기가 작아진만큼 늘려주는 값
                            let tempRedBallWidth = CGFloat(self.redBallWidth) - CGFloat(self.redBall.frame.width);
                            let tempRedBallHeight = CGFloat(self.redBallHeight) - CGFloat(self.redBall.frame.height);
                            
                            self.redBallLeftPosition.constant = CGFloat(self.redBallPositionArray[temp][0]) + tempRedBallWidth;
                            self.redBallTopPosition.constant = CGFloat(self.redBallPositionArray[temp][1]) + tempRedBallHeight;
                             
                    
                            self.gameCount = self.gameCount - 1;
                             

                         }
                    
                }

                
            }//sync
                   
            
            
            
            
            
            
        }else if( gameCount == 1)
        {
            print("게임 종료");
            
            gameEndBool = true;
            
            
            //게임 종료 안내 함수
            gameEnd();
            
        }
        
        
        
    }
    
    
    func gameEnd()
    {
        //게임 끝났을때
        if( gameEndBool )
        {
            
            self.view.isUserInteractionEnabled = false;
            self.redBall.isUserInteractionEnabled = false;
            
            //타이머 종료
            timer.invalidate();
            timerView.invalidate();
            
            
            var alertMessege = String();
            
            //인터넷 연결 체크
            if ConnectionCheck.isConnectedToNetwork() {
                //print("Connected")
                alertMessege = NSLocalizedString("time", comment: "") + " : " + String(describing: self.duration/10000) + NSLocalizedString("second", comment: "") + "\n\n" + NSLocalizedString("set_name", comment: "") + "\n\n" + NSLocalizedString("rank_record", comment: "");
                
            }else{
                //print("Not Connected")
                alertMessege = NSLocalizedString("time", comment: "") + " : " + String(describing: self.duration/10000) + NSLocalizedString("second", comment: "");
            }
            
            
            //alert 뛰우기
            let alertController = UIAlertController(title: NSLocalizedString("success", comment: ""), message: alertMessege, preferredStyle: .alert)

            //인터넷 연결 체크
            if ConnectionCheck.isConnectedToNetwork() {
                //print("Connected")
                //alert에 텍스트 필드 추가하기
                alertController.addTextField { (UITextField) in
                    
                }
                
            }else{
                //print("Not Connected")
            }
            
            
            var okButton = UIAlertAction();
            //인터넷 연결 체크
            if ConnectionCheck.isConnectedToNetwork() {
                
                 okButton = UIAlertAction(title: NSLocalizedString("submit", comment: ""), style: .default, handler: { (action) -> Void in
                    //print("Ok button tapped")

                    
                        if( alertController.textFields?[0].text! != "" ) //값이 있을때
                        {
                            //print(alertController.textFields?[0].text! ?? "");
                            let userName = alertController.textFields?[0].text! ?? "";
                            let userNameLength = userName.utf8.count
                            print(userNameLength)
                            
                            if( userNameLength < 4)
                            {
                                //이름을 좀 더 길게 입력해주세요 alert 뛰우기
                                let alertMessege3 = NSLocalizedString("short_name", comment: "");
                                let alertController3 = UIAlertController(title: NSLocalizedString("error", comment: ""), message: alertMessege3, preferredStyle: .alert)
                                let okButton3 = UIAlertAction(title: NSLocalizedString("done", comment: ""), style: .default, handler: { (action) -> Void in
                                    //print("Ok button tapped")
                                    self.gameEnd();
                                })
                                alertController3.addAction(okButton3);
                                self.present(alertController3, animated: true, completion: nil)
                                
                                //진동 에러
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.error)
                                
                                
                            }else if( userNameLength >= 30)
                            {
                                //이름을 좀 더 짧게 입력해주세요 alert 뛰우기
                                let alertMessege3 = NSLocalizedString("long_name", comment: "");
                                let alertController3 = UIAlertController(title: NSLocalizedString("error", comment: ""), message: alertMessege3, preferredStyle: .alert)
                                let okButton3 = UIAlertAction(title: NSLocalizedString("done", comment: ""), style: .default, handler: { (action) -> Void in
                                    //print("Ok button tapped")
                                    self.gameEnd();
                                })
                                alertController3.addAction(okButton3);
                                self.present(alertController3, animated: true, completion: nil)
                                
                                //진동 에러
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.error)
                                
                            }else{
                                //print("등록 직전");
                                
                                self.ajaxUpload(userName: userName, userTime: self.duration/10000)
                                
                            }
                                
                            
                        }else{ //값이 없을때
                            print("값이 없다")
                            
                            //이름 입력 alert 뛰우기
                            let alertMessege2 = NSLocalizedString("set_name", comment: "");
                            let alertController2 = UIAlertController(title: NSLocalizedString("error", comment: ""), message: alertMessege2, preferredStyle: .alert)
                            let okButton2 = UIAlertAction(title: NSLocalizedString("done", comment: ""), style: .default, handler: { (action) -> Void in
                                //print("Ok button tapped")
                                self.gameEnd();
                            })
                            alertController2.addAction(okButton2);
                            self.present(alertController2, animated: true, completion: nil)
                            
                            //진동 에러
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.error)
                            
                            
                        }
                        

                    
                    
                    
                 })
                
            }else{//인터넷 연결 안되었을때
                
                okButton = UIAlertAction(title: NSLocalizedString("home", comment: ""), style: .default, handler: { (action) -> Void in

                    //화면 종료
                    self.viewDismiss();
                    
                })

                
            }
            

//            let replayButton = UIAlertAction(title: "재시도", style: .default, handler: { (action) -> Void in
//                //print("Ok button tapped")
//                self.gameStartInit();
//            })
            let homeButton = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .destructive, handler: { (action) -> Void in
                //print("Ok button tapped")
                self.viewDismiss();
            })

            
            alertController.addAction(okButton);
            //alertController.addAction(replayButton);
            alertController.addAction(homeButton);

                
                

            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //화면 종료
    func viewDismiss()
    {
        DispatchQueue.main.async() {
            //화면 종료
            self.view.backgroundColor = UIColor.black;
            self.infoLabel.text = "";
            self.redBall.isHidden = true;
            
            //옵저버 포스트 날리기
            let noti = Notification.init(name : Notification.Name(rawValue: "statusBarOn"));
            NotificationCenter.default.post(noti);
            
            self.presentingViewController?.dismiss(animated: true);
        }
    }
    
    
    //사용자 기록 디비 등록
    func ajaxUpload(userName : String, userTime : Float)
    {
        DispatchQueue.main.async() {
            self.loadingView.isHidden = false;
        }
        
        //디바이스 체크
        var user_device = String();
        if UIDevice.current.userInterfaceIdiom == .phone{
            user_device = "iPhone";
            
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            user_device = "iPad";
        }
        
        
        let user_name : String = userName;
        let user_time : String = String(describing: userTime);
        
        
        let user_device_model : String = ViewGameController.deviceModel()
        

        
//        print(user_name);
//        print(user_time);
        
        
        let param : String = "user_name="+user_name+"&user_time="+user_time+"&user_device="+user_device+"&user_device_model="+user_device_model;
        
            
        Ajax.forecast(withUrl: "http://hansbuild.cafe24.com/touchking/ajax_user_insert.php", withParam: param) { (results:[[String:Any]]) in
            
            
            for result in results{
                if (result["error"] != nil){
                    //에러발생시
                    print(result["error"] ?? "error")
                    let alertController = UIAlertController(title: NSLocalizedString("error", comment: ""), message: "\(String(describing: result["error"]!))", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: NSLocalizedString("done", comment: ""), style: .default , handler: { (action) -> Void in
                        
                        //화면 종료
                        self.viewDismiss();
                        
                    })
                    
                    alertController.addAction(okButton)
                    
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    print("php 정상 작동!");
                    
                    print(result["user_name"]!)
                    print(result["user_time"]!)
                    print(result["user_device"]!)
                    print(result["user_device_model"]!)
                    //let status : String = String(describing: result["status"]!)

                    
                    let alertController = UIAlertController(title: NSLocalizedString("save_success", comment: ""), message: NSLocalizedString("save_success_info", comment: ""), preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: NSLocalizedString("done", comment: ""), style: .default , handler: { (action) -> Void in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            //화면 종료
                            self.viewDismiss();
                        }
                        
                    })
                    
                    alertController.addAction(okButton)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    //화면 종료
                    //self.viewDismiss();
                    
                }
            }
            
            
            
        }//ajax
            
        
        
        
    }
    
    
    
    //게임 시작
    func gameStart()
    {
        if(gameEndBool)
        {
            self.view.backgroundColor = UIColor.red;
            infoLabel.text = "Touch!";
            timerStart();
        }
    }
    
    
    func timerStart()
    {
        //타이머 종료 및 초기화
        self.timer.invalidate();
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.0001, repeats: true, block: { (Timer) in
            self.duration = self.duration + 1;
            
            //print(self.duration/10000)
        })
    }
    
    
    func timerViewStart()
    {
        //타이머 종료 및 초기화
        self.timerView.invalidate();
        
        timerView = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
            //self.duration = self.duration + 1;
            
            DispatchQueue.main.async() {
                //self.timeCountLabel.text = String(self.duration/10000) + " s";
                self.timeCountLabel.text = String(format: "%.1f",  self.duration/10000) + " " + NSLocalizedString("second", comment: "");
                
            }
            //print(self.duration/10000)
        })
    }
    

    
    
        ///Identifier 찾기

        static func getDeviceIdentifier() -> String {

            var systemInfo = utsname()

            uname(&systemInfo)

            let machineMirror = Mirror(reflecting: systemInfo.machine)

            let identifier = machineMirror.children.reduce("") { identifier, element in

                guard let value = element.value as? Int8, value != 0 else { return identifier }

                return identifier + String(UnicodeScalar(UInt8(value)))

            }

            

            return identifier

        }


        

        /**

         device 모델 이름

        */

        static func deviceModel() -> String {

            

            let identifier = self.getDeviceIdentifier()

            
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator"
            default:                                        return "Unknown"
            }
            

        }

        


}
