//
//  ViewRankController.swift
//  quicktouch
//
//  Created by nuri Lee on 15/01/2020.
//  Copyright © 2020 nuri Lee. All rights reserved.
//

import UIKit

class ViewRankController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //라이트모드
        overrideUserInterfaceStyle = .light
        
        //제목 설정
        if UIDevice.current.userInterfaceIdiom == .phone{
            rankTitleLabel.text = "iPhone " + NSLocalizedString("rank_title", comment: "");
            
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            rankTitleLabel.text = "iPad " + NSLocalizedString("rank_title", comment: "");
        }
        
        
        

        //초기화
        rankInit();

    }
    
    @IBAction func btnDimiss(_ sender: Any) {
        self.dismiss(animated: true);
    }
    @IBOutlet weak var rankTitleLabel: UILabel!
    
    @IBOutlet weak var todayTableView: UITableView!
    
    @IBOutlet weak var todayTableViewHeightConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var allTableView: UITableView!
    @IBOutlet weak var allTableViewHeightConstraint: NSLayoutConstraint!
    
    var array1 = ["dlsnf", "dlsnf","dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf"]
    var array2 = ["dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf", "dlsnf"]
    
    
    var arrayTodayRank: [[String: Any]] = [[String:Any]]();
    var arrayAllRank: [[String: Any]] = [[String:Any]]();
    
    
    
    
    var todayTableViewHeight = CGFloat();
    var allTableViewHeight = CGFloat();
    
    var todayRankNumber : Int = 0;
    var allRankNumber : Int = 0;
    
    
    
    func rankInit()
    {
        
        self.todayTableView.isScrollEnabled = false;
        self.allTableView.isScrollEnabled = false;
        
        self.todayTableView.isHidden = true;
        self.allTableView.isHidden = true;
        
        //테이블 뷰 height 동적으로 관리하기
        self.todayTableView.rowHeight = UITableView.automaticDimension;
        self.allTableView.rowHeight = UITableView.automaticDimension;
        
        todayRankNumber = 0;
        allRankNumber = 0;
        
        
        //에이젝스 불러오기 -all이랑 tablereload까지 됨
        ajaxSelectTodayScore();
    }
    
    
    func ajaxSelectTodayScore()
    {
        //디바이스 체크
        var user_device = String();
        if UIDevice.current.userInterfaceIdiom == .phone{
            user_device = "iPhone";
            
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            user_device = "iPad";
        }
        
        let today : String = "today";

        let param : String = "user_device="+user_device+"&today="+today;
        
            
        Ajax.forecast(withUrl: "http://hansbuild.cafe24.com/touchking/ajax_user_score_select.php", withParam: param) { (results:[[String:Any]]) in
            
            
            if( results.count == 0) //값이 하나도 없을때
            {

                self.ajaxSelectAllScore();
                
            }else if (results[0]["error"] != nil){ //에러가 있을때
                //에러발생시
                print(results[0]["error"] ?? "error")
                let alertController = UIAlertController(title: "error", message: "\(String(describing: results[0]["error"]!))", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "확인", style: .default , handler: { (action) -> Void in
                    
                    //화면 종료
                    //self.viewDismiss();
                    
                })
                
                alertController.addAction(okButton)
                
                self.present(alertController, animated: true, completion: nil)
                
            }else{//ajax 가성공적일때
                
                self.arrayTodayRank = results;
                self.ajaxSelectAllScore();
                
            }
            
            

        }//ajax
    }
    
    func ajaxSelectAllScore()
    {
        //디바이스 체크
        var user_device = String();
        if UIDevice.current.userInterfaceIdiom == .phone{
            user_device = "iPhone";
            
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            user_device = "iPad";
        }
        
        let today : String = "all";

        let param : String = "user_device="+user_device+"&today="+today;
        
            
        Ajax.forecast(withUrl: "http://hansbuild.cafe24.com/touchking/ajax_user_score_select.php", withParam: param) { (results:[[String:Any]]) in
            
            
            if( results.count == 0) //값이 하나도 없을때
            {

                self.tableUpdate();
                
            }else if (results[0]["error"] != nil){ //에러가 있을때
                //에러발생시
                print(results[0]["error"] ?? "error")
                let alertController = UIAlertController(title: "error", message: "\(String(describing: results[0]["error"]!))", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "확인", style: .default , handler: { (action) -> Void in
                    
                    //화면 종료
                    //self.viewDismiss();
                    
                })
                
                alertController.addAction(okButton)
                
                self.present(alertController, animated: true, completion: nil)
                
            }else{//ajax 가성공적일때
                
                self.arrayAllRank = results;
                
                self.tableUpdate();
                
            }
            
            

        }//ajax
    }
    
    
    func tableUpdate()
    {
        
        DispatchQueue.main.async() {
            self.todayTableView.reloadData();
            self.allTableView.reloadData();
            
            self.todayTableView.isHidden = false;
            self.allTableView.isHidden = false;
        }
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if( tableView == todayTableView)
        {
            if(self.arrayTodayRank.count == 0)//배열에 아무런 값이 없을때
            {
                return 1
            }
            return arrayTodayRank.count
        }else{
            if(self.arrayAllRank.count == 0)//배열에 아무런 값이 없을때
            {
                return 1
            }
            return arrayAllRank.count
        }
        
        
        
    }
    
    
    
    //테이블 셀 height 동적 관리
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }


    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if( tableView == todayTableView)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! tableCellTodayRank
            
            if(self.arrayTodayRank.count == 0)//배열에 아무런 값이 없을때
            {
                cell.firstRankLabel.isHidden = false;
                cell.firstRankLabel.text = NSLocalizedString("firstRankToday", comment: "가장먼저 차지")
                cell.rankCountLabel.text = "";
                cell.userNameLabel.text = ""
                cell.userTimeLabel.text = "";
                cell.userDeviceCountryLabel.text = "";
                cell.date_time.text = "";
            }else{
                cell.firstRankLabel.isHidden = true;
                cell.rankCountLabel.text = String(describing: indexPath.row + 1) + ".";
                cell.userNameLabel.text = (self.arrayTodayRank[indexPath.row]["user_name"] as! String);
                cell.userTimeLabel.text = (self.arrayTodayRank[indexPath.row]["user_time_2"] as! String) + " " + NSLocalizedString("second", comment: "");
                cell.userDeviceCountryLabel.text = (self.arrayTodayRank[indexPath.row]["user_device_model"] as! String) + " / " + (self.arrayTodayRank[indexPath.row]["user_country"] as! String);
                cell.date_time.text = (self.arrayTodayRank[indexPath.row]["date_time2"] as! String);
            }
            //cell.titleLabel.text = array1[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! tableCellAllRank
            
            
            if(self.arrayAllRank.count == 0)//배열에 아무런 값이 없을때
            {
                cell.firstRankLabel.isHidden = false;
                cell.firstRankLabel.text = NSLocalizedString("firstRankAll", comment: "가장먼저 차지")
                cell.rankCountLabel.text = "";
                cell.userNameLabel.text = "";
                cell.userTimeLabel.text = "";
                cell.userDeviceCountryLabel.text = "";
                cell.date_time.text = "";
            }else{
                cell.firstRankLabel.isHidden = true;
                cell.rankCountLabel.text = String(describing: indexPath.row + 1) + ".";
                cell.userNameLabel.text = (self.arrayAllRank[indexPath.row]["user_name"] as! String);
                cell.userTimeLabel.text = (self.arrayAllRank[indexPath.row]["user_time_2"] as! String) + " " + NSLocalizedString("second", comment: "");
                cell.userDeviceCountryLabel.text = (self.arrayAllRank[indexPath.row]["user_device_model"] as! String) + " / " + (self.arrayAllRank[indexPath.row]["user_country"] as! String);
                cell.date_time.text = (self.arrayAllRank[indexPath.row]["date_time2"] as! String);
            }
            
            
            return cell
        }
        
        
        
    }
    
    
    //셀이 다 끝났을때 did load
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        //테이블 투데이
        if (cell.tag == 1)
        {
            DispatchQueue.main.async() {
            
                //print(self.todayTableView.contentSize.height);
                self.todayTableViewHeight = self.todayTableView.contentSize.height;
                self.todayTableViewHeightConstraint.constant = self.todayTableViewHeight;
            }
        }
        
        //테이블 올
        if (cell.tag == 2)
        {
            DispatchQueue.main.async() {

                //print(self.allTableView.contentSize.height);
                self.allTableViewHeight = self.allTableView.contentSize.height;
                self.allTableViewHeightConstraint.constant = self.allTableViewHeight;
            }
                
            //self.allTableViewHeightConstraint.constant = CGFloat(self.arrayAllRank.count * 44);

        }
        
    }
    
    
    
    
}
