//
//  ViewMultiController.swift
//  quicktouch
//
//  Created by nuri Lee on 26/01/2020.
//  Copyright © 2020 nuri Lee. All rights reserved.
//
import UIKit

class ViewMultiController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //라이트모드
        overrideUserInterfaceStyle = .light
        
        gameStartInit();
        
        
        //레드볼 탭
        let tapGeustureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.viewTap2(recognizer:)))
        tapGeustureRecognizer2.numberOfTapsRequired = 1;
        self.redBall.isUserInteractionEnabled = true;
        self.redBall.addGestureRecognizer(tapGeustureRecognizer2);
        
        //블루볼 탭
        let tapGeustureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(self.viewTap3(recognizer:)))
        tapGeustureRecognizer3.numberOfTapsRequired = 1;
        self.blueBall.isUserInteractionEnabled = true;
        self.blueBall.addGestureRecognizer(tapGeustureRecognizer3);
        
        
        //레드 백그라운드 탭
        let tapGeustureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(self.viewTap4(recognizer:)))
        tapGeustureRecognizer4.numberOfTapsRequired = 1;
        self.playerOneBack.isUserInteractionEnabled = true;
        self.playerOneBack.addGestureRecognizer(tapGeustureRecognizer4);
        
        //블루 백그라운드 탭
        let tapGeustureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(self.viewTap5(recognizer:)))
        tapGeustureRecognizer5.numberOfTapsRequired = 1;
        self.playerTwoBack.isUserInteractionEnabled = true;
        self.playerTwoBack.addGestureRecognizer(tapGeustureRecognizer5);
        
        

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);

        print("화면 사라짐")
        
        //게임스타트타이머 종료
        self.gameStartTimer.invalidate();
        
    }
    
    
    
    //레드볼  탭했을때
    @objc func viewTap2(recognizer : UITapGestureRecognizer){
        //print("tap");
        //let point = recognizer.location(in: view);
        //print(point);
     
         //레드볼 눌렀을때 함수 실행
         redBallTouch();
     }
    
    //레드볼  탭했을때
    @objc func viewTap3(recognizer : UITapGestureRecognizer){
        //print("tap");
        //let point = recognizer.location(in: view);
        //print(point);
     
         //블루볼 눌렀을때 함수 실행
         blueBallTouch();
     }
    
    //레드 백그라운드 탭했을때
    @objc func viewTap4(recognizer : UITapGestureRecognizer){
        //print("tap");
        //let point = recognizer.location(in: view);
        //print(point);
     
         //레드 백그라운드 터치했을때
        redBackTouch();
     }
    
    //블루 백그라운드 탭했을때
    @objc func viewTap5(recognizer : UITapGestureRecognizer){
        //print("tap");
        //let point = recognizer.location(in: view);
        //print(point);
     
         //블루 백그라운드 터치했을때
        blueBackTouch();
     }
    
    

    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: RotateLabel!
    @IBOutlet weak var redBall: Dot!
    @IBOutlet weak var redBallLabel: UILabel!
    @IBOutlet weak var redBallLeftPosition: NSLayoutConstraint!
    @IBOutlet weak var redBallTopPosition: NSLayoutConstraint!
    @IBOutlet weak var blueBall: Dot!
    @IBOutlet weak var blueBallLabel: RotateLabel!
    @IBOutlet weak var blueBallLeftPosition: NSLayoutConstraint!
    @IBOutlet weak var blueBallTopPosition: NSLayoutConstraint!
    
    @IBOutlet weak var playerOneBack: UIStackView!
    @IBOutlet weak var playerTwoBack: UIStackView!
    
    @IBOutlet weak var playerOneBackView: UIView!
    @IBOutlet weak var playerTwoBackView: UIView!
    @IBOutlet var playerOneLifes: [UIImageView]!
    @IBOutlet var playerTwoLifes: [RotateImageView]!
    
    @IBOutlet weak var playerOneCrown: UIImageView!
    @IBOutlet weak var playerTwoCrown: RotateImageView!
    @IBAction func btnDismissPress(_ sender: Any) {
       
        self.viewDismiss();
    }
    
    
    
    //레드볼 관련 변수들
    var redBallCount : Float = 20; //레드볼 갯수
    var redGameCount : Float = 1; //게임 처음 시작 카운트
    var redBallMinDistance : Float = 30; //레드볼 최소 간격
    var redBallPositionArray : [[Float]] = Array() ; //좌표 배열
    var redBallWidth = Float(); //레드볼 가로크기
    var redBallHeight = Float(); //레드볼 세로크기
    var redLifeDefine : Int = 3;
    var redLife : Int = 3;
    
    //블루볼 관련 변수들
    var blueBallCount : Float = 20; //레드볼 갯수
    var blueGameCount : Float = 1; //게임 처음 시작 카운트
    var blueBallMinDistance : Float = 30; //레드볼 최소 간격
    var blueBallPositionArray : [[Float]] = Array() ; //좌표 배열
    var blueBallWidth = Float(); //레드볼 가로크기
    var blueBallHeight = Float(); //레드볼 세로크기
    
    var blueLifeDefine : Int = 3;
    var blueLife : Int = 3;
       
    
    //볼 공통 함수
    var ballWidth = Float(); //볼 가로크기
    var ballHeight = Float(); //볼 세로크기
    var ballCount : Float = 20;
    var ballMinDistance : Float = 100; //볼 최소 간격
    
    
    //게임 시작한건지 체크
    var gameEndBool : Bool = false;
    
    
    //게임 시작 타이머
    var gameStartTimer = Timer();
    var gameStartDuration : Float = 0;
    
    //게임 시작되는 시간
    var gameStartTime : Float = 0;
    
    
    var screenWidth = Float();
    var screenHeight = Float();
    
    
    
    
    
    
    func gameStartInit()
    {
        gameEndBool = false;
        gameStartDuration = 0;
        redGameCount = ballCount;
        blueGameCount = ballCount;
        
        redLife = redLifeDefine; //life 3
        blueLife = blueLifeDefine;
        
        DispatchQueue.main.async() {
            self.playerOneLabel.textColor = UIColor.white;
            self.playerTwoLabel.textColor = UIColor.white;
            self.playerOneLabel.text = NSLocalizedString("ready", comment: "");
            self.playerTwoLabel.text = NSLocalizedString("ready", comment: "");
            
            self.playerOneCrown.isHidden = true;
            self.playerTwoCrown.isHidden = true;
        }
        
        //레드볼 블루볼 좌표값 초기화
        redBallPositionArray = Array(repeating: Array(repeating: 0,count:2 ), count: Int(redBallCount));
        blueBallPositionArray = Array(repeating: Array(repeating: 0,count:2 ), count: Int(blueBallCount));
        
        
        //1~3사이 랜덤 숫자
        let randomNum: UInt32 = arc4random_uniform(3) + 1;
        
        //게임 시작되는 시간
        gameStartTime = Float(randomNum) + 2;
        
        //글로벌 값 저장
        UserDefaults.standard.set(false, forKey: "gameBoolGlobal");
        
        
        self.view.isUserInteractionEnabled = true;
        
        //볼 초기화
        self.redBall.isHidden = true;
        self.redBallLabel.text = String(format: "%.0f", ballCount);
        self.redBall.isUserInteractionEnabled = true;
        self.blueBall.isHidden = true;
        self.blueBallLabel.text = String(format: "%.0f", ballCount);
        self.blueBall.isUserInteractionEnabled = true;

        BallPositionInit(playerNum: 1);//1p 레드볼 포지션 초기화
        BallPositionInit(playerNum: 2);//2p 블루볼 포지션 초기화
        
        
        //게임 시작 타이머 가동
        gameTimerStart();
        
        print("게임 시작시간 : " + String(describing: gameStartTime) + "초 후");
        
        
        //라이프 초기화
        lifeInit(lifeCount: redLifeDefine); //3
    }
    
    
    //생명 초기화
    func lifeInit(lifeCount : Int)
    {
        if( lifeCount >= 0 )
        {
            
            for i in 0...(lifeCount - 1) { //0, 1, 2
                print(i);
                playerOneLifes[i].isHidden = false;
                playerTwoLifes[i].isHidden = false;
            }

        }//>= 0 if
        
    }
    
    //생명 깍기
    func lifeBreak(playerNum : Int) -> Bool
    {
        //진동 강하게
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        if( playerNum == 1) //레드볼 1p일떄
        {

            //화면 경고주기
            DispatchQueue.main.async() {
                
                self.playerOneBackView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping:2,
                               initialSpringVelocity:0,
                               options: .curveEaseInOut,
                               animations: {
                                self.playerOneBackView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                                
                                
                }, completion: { (finished) -> Void in
                    //print("end");
                    
                })
            }
            
            //생명력 없을때
            if(redLife == 1)
            {
                playerOneLifes[0].isHidden = true;
                
                //false 반환
                return false;
            }
            
            redLife = redLife - 1;
            if(redLife >= 0)
            {
                playerOneLifes[redLife].isHidden = true;
            }
            
            
        }else{
            
            //화면 경고주기
            DispatchQueue.main.async() {
                
                self.playerTwoBackView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping:2,
                               initialSpringVelocity:0,
                               options: .curveEaseInOut,
                               animations: {
                                self.playerTwoBackView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                                
                                
                }, completion: { (finished) -> Void in
                    //print("end");
                    
                })
            }
            
            
            //생명력 없을때
            if(blueLife == 1)
            {
                
                playerTwoLifes[0].isHidden = true;
                
                //false 반환
                return false;
            }
            
            blueLife = blueLife - 1;
            if(blueLife >= 0)
            {
                playerTwoLifes[blueLife].isHidden = true;
            }
          
        }
        
        return true;
    }
    
    
    //레드, 블루볼 포지션 초기화
    func BallPositionInit(playerNum : Int)
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
        
        
        if( playerNum == 1) //레드볼 1p일떄
        {
            ballWidth = Float(redBall.frame.width);
            ballHeight = Float(redBall.frame.height);
        }else{
            ballWidth = Float(blueBall.frame.width);
            ballHeight = Float(blueBall.frame.height);
        }

        

                
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
        var preBallPoint = CGPoint();
        if( playerNum == 1) //레드볼 1p일떄
        {
            preBallPoint = CGPoint(x: CGFloat(redBallPositionArray[0][0]), y: CGFloat(redBallPositionArray[0][1]));
        }else{
            preBallPoint = CGPoint(x: CGFloat(blueBallPositionArray[0][0]), y: CGFloat(blueBallPositionArray[0][1]));
        }
        
        
        //게임 수 만큼 반복
        var i : Int = 0;
        while(i < Int(ballCount))
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
                newPoint_y = arc4random_uniform(UInt32(screenHeight/2)) + 0; //스크린 높이 반 사이즈만큼 랜덤 생성
                let newBallPoint = CGPoint(x: CGFloat(newPoint_x), y: CGFloat(newPoint_y));
                
                //좌표 생성 가능한지 체크
                checkBool = randomPositionCheck(prePoint: preBallPoint, newPoint: newBallPoint, ballMinDistance : ballMinDistance, ballWidth: ballWidth, ballHeight: ballHeight, topPadding: topPadding, bottomPadding: bottomPadding, leftPadding: leftPadding, rightPadding: rightPadding, screenWidth: screenWidth, screenHeight: screenHeight);
                
            }
            

            //checkBool이 트루이면 좌표값 입력
            if(checkBool)
            {
                //print("좌표 등록 성공!");
                
                if( playerNum == 1) //레드볼 1p일떄
                {
                    redBallPositionArray[i][0] = Float(newPoint_x);
                    redBallPositionArray[i][1] = Float(newPoint_y);
                    //전 포인트 저장
                    preBallPoint = CGPoint(x: CGFloat(redBallPositionArray[i][0]), y: CGFloat(redBallPositionArray[i][1]));
                }else{
                    blueBallPositionArray[i][0] = Float(newPoint_x);
                    blueBallPositionArray[i][1] = Float(newPoint_y);
                    //전 포인트 저장
                    preBallPoint = CGPoint(x: CGFloat(blueBallPositionArray[i][0]), y: CGFloat(blueBallPositionArray[i][1]));
                }
                
            }else{
                //print("좌표 등록 실패!");
            }

            
            
            i += 1;
        }//while
        
        
        //2차원 배열 프린트
        arrayPrint(playerNum: playerNum);
        
                
        
    }
        
        
        
    //2차원 배열 프린트
    func arrayPrint(playerNum : Int)
    {
        if(playerNum == 1)//1p 레드볼일때
        {
            print("");
            print("1P 레드볼 좌표 정보");
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
        }else{
            print("");
            print("2P 블루볼 좌표 정보");
            var i : Int = 0;
            while(i < Int(redBallCount)) //수정 변수 필요 - redBallCount
            {
                
                let temp = i + 1;
                print(temp, terminator:"");
                print("번째 좌표값 (", terminator:"")
                print( blueBallPositionArray[i][0], terminator:"");
                print(", ", terminator:"")
                print( blueBallPositionArray[i][1], terminator:"");
                print(")");
                
                i += 1;
            }
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
            if( preNewDistance >= ballMinDistance)
            {
                //safe area에 겹치는지 체크
                //왼쪽 또는 오른쪽 겹치는지 체크
                if( newPoint_x >= leftPadding && (newPoint_x) <= (screenWidth - leftPadding - rightPadding - ballWidth))
                {
                    
                    //위쪽 또는 아래 겹치는지 체크 //높이의 반만 체크
                    if( newPoint_y >= topPadding && (newPoint_y) <= (screenHeight/2 - topPadding - bottomPadding - ballHeight))
                    {

                        result = true;
                    }
                }
            }
            
            
            
            
            //print("랜덤 포지션 체크 끝")
            
            
            return result;
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
                
                //게임 시작
                self.gameStart();
            }
        })
        
    }
    
    func gameStart()
    {
        
        
        DispatchQueue.main.async() {
            
            //레드볼 화면 이동
            self.redBallLeftPosition.constant = CGFloat(self.redBallPositionArray[0][0]);
            self.redBallTopPosition.constant = CGFloat(self.redBallPositionArray[0][1]);
            self.redBall.isHidden = false;
            
            //블루볼 화면 이동
            self.blueBallLeftPosition.constant = CGFloat(self.blueBallPositionArray[0][0]);
            self.blueBallTopPosition.constant = CGFloat(self.blueBallPositionArray[0][1]);
            self.blueBall.isHidden = false;
            
        }
        
        
        DispatchQueue.main.async() {
            self.playerOneLabel.text = NSLocalizedString("go", comment: "");
            self.playerTwoLabel.text = NSLocalizedString("go", comment: "");
        }
        
        
        
    }
    //gameStart
    
    //레드볼 눌렀을때
    func redBallTouch()
    {
        

        //진동 강하게
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        //처음 눌렀을때
        if(redGameCount == ballCount)
        {
            DispatchQueue.main.async() {
                self.playerOneLabel.text = "";
            }
        }
        
        
        
        //눌러야할게 남았을때
        if( redGameCount > 1)
        {
            
           
            
            DispatchQueue.main.async() {
                
                let temp : Int = Int(self.redGameCount - 1);
                
                DispatchQueue.main.async() {
                self.redBallLabel.text = String(describing: temp);
                    
                

                        
                         DispatchQueue.main.async() {

                            //self.infoLabel.text = "";
                             
                            let temp : Int = Int(self.redGameCount - 1);
                            //print(temp);
                             
                            
                            //레드볼 좌표 설정
                            self.redBallLeftPosition.constant = CGFloat(self.redBallPositionArray[temp][0]);
                            self.redBallTopPosition.constant = CGFloat(self.redBallPositionArray[temp][1]);
                             
                    
                            self.redGameCount = self.redGameCount - 1;
                             

                         }
                    
                }

                
            }//sync
                   
            
            
            
            
            
            
        }else if( redGameCount == 1)
        {
            print("게임 종료");
            
            gameEndBool = true;
            
            
            //게임 종료 안내 함수
            gameEnd(playerNum : 1);
            
        }
        
        
        
    }
    //redTouch
    
    //블루볼 눌렀을때
    func blueBallTouch()
    {
        

        //진동 강하게
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        //처음 눌렀을때
        if(blueGameCount == ballCount)
        {
            DispatchQueue.main.async() {
                self.playerTwoLabel.text = "";
            }
        }
        
        
        
        //눌러야할게 남았을때
        if( blueGameCount > 1)
        {
            
           
            
            DispatchQueue.main.async() {
                
                let temp : Int = Int(self.blueGameCount - 1);
                
                DispatchQueue.main.async() {
                self.blueBallLabel.text = String(describing: temp);
                    
                

                        
                         DispatchQueue.main.async() {

                            //self.infoLabel.text = "";
                             
                            let temp : Int = Int(self.blueGameCount - 1);
                            //print(temp);
                             
                            
                            //레드볼 좌표 설정
                            self.blueBallLeftPosition.constant = CGFloat(self.blueBallPositionArray[temp][0]);
                            self.blueBallTopPosition.constant = CGFloat(self.blueBallPositionArray[temp][1]);
                             
                    
                            self.blueGameCount = self.blueGameCount - 1;
                             

                         }
                    
                }

                
            }//sync
                   
            
            
            
            
            
            
        }else if( blueGameCount == 1)
        {
            print("게임 종료");
            
            gameEndBool = true;
            
            
            //게임 종료 안내 함수
            gameEnd(playerNum : 2);
            
        }
        
        
        
    }
    //blueTouch
    
    
    func gameEnd(playerNum : Int)
    {
        //게임 끝났을때
        if( gameEndBool )
        {
            //진동 성공
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            
            gameStartTimer.invalidate();
            
            self.view.isUserInteractionEnabled = false;
            self.redBall.isUserInteractionEnabled = false;
            self.blueBall.isUserInteractionEnabled = false;
            
            
            var alertMessege = String();

            if( playerNum == 1) //레드볼 1p일떄
            {
                alertMessege = NSLocalizedString("red_win", comment: "");
                DispatchQueue.main.async() {
                    //self.playerOneLabel.textColor = UIColor(red: 255/255.0, green: 38/255.0, blue: 0/255.0, alpha: 1.0);
                    //self.playerTwoLabel.textColor = UIColor.white;
                    self.playerOneLabel.text = NSLocalizedString("win", comment: "");
                    self.playerTwoLabel.text = NSLocalizedString("lose", comment: "");
                    self.playerOneCrown.isHidden = false;
                    self.playerTwoCrown.isHidden = true;
                }
            }else{
                alertMessege = NSLocalizedString("blue_win", comment: "");
                DispatchQueue.main.async() {
                    //self.playerOneLabel.textColor = UIColor.white;
                    //self.playerTwoLabel.textColor = UIColor(red: 51/255.0, green: 111/255.0, blue: 234/255.0, alpha: 1.0);
                    self.playerOneLabel.text = NSLocalizedString("lose", comment: "");
                    self.playerTwoLabel.text = NSLocalizedString("win", comment: "");
                    self.playerOneCrown.isHidden = true;
                    self.playerTwoCrown.isHidden = false;
                }
            }
            
            
            

            
            
            
            //alert 뛰우기
            let alertController = UIAlertController(title: alertMessege, message: "", preferredStyle: .alert)


            var okButton = UIAlertAction();
            var replayButton = UIAlertAction();
            
            if( playerNum == 1) //레드볼 1p일떄 빨간 버튼
            {
                
                okButton = UIAlertAction(title: NSLocalizedString("home", comment: ""), style: .destructive, handler: { (action) -> Void in
                    //print("Ok button tapped")

                    //화면 종료
                    self.viewDismiss();
               
                    
                 })
                replayButton = UIAlertAction(title: NSLocalizedString("replay", comment: ""), style: .destructive, handler: { (action) -> Void in
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
                
            }else{ //블루팀이 이겼을때 파란버튼
                okButton = UIAlertAction(title: NSLocalizedString("home", comment: ""), style: .default, handler: { (action) -> Void in
                     //print("Ok button tapped")

                     //화면 종료
                     self.viewDismiss();
                
                     
                  })
                 replayButton = UIAlertAction(title: NSLocalizedString("replay", comment: ""), style: .default, handler: { (action) -> Void in
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
            }

            
            alertController.addAction(okButton);
            alertController.addAction(replayButton);

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //화면 종료
    func viewDismiss()
    {
        DispatchQueue.main.async() {
            //화면 종료

            //status bar On 옵저버 포스트 날리기
            let noti = Notification.init(name : Notification.Name(rawValue: "statusBarOn"));
            NotificationCenter.default.post(noti);
            
            self.presentingViewController?.dismiss(animated: true);
        }
    }

    func redBackTouch()
    {
        //print("1p 레드 백그라운드 탭");
        
        if(lifeBreak(playerNum: 1))
        {
            //print("생명력 -1");
        }else{
            print("게임 종료 레드팀 패배");
            gameEndBool = true;

            //게임 종료 안내 함수
            gameEnd(playerNum : 2);
        }
        
        
    }
    
    func blueBackTouch()
    {
        if(lifeBreak(playerNum: 2))
        {
            //print("생명력 -1");
        }else{
            print("게임 종료 블루팀 패배");
            gameEndBool = true;
            
            //게임 종료 안내 함수
            gameEnd(playerNum : 1);
        }
    }

    
    
    
}
