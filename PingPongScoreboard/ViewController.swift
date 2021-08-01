//
//  ViewController.swift
//  PingPongScoreboard
//
//  Created by 蔡忠翊 on 2021/7/29.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var rScore: UILabel!
    @IBOutlet weak var lScore: UILabel!
    @IBOutlet weak var lGame: UILabel!
    @IBOutlet weak var rGame: UILabel!
    @IBOutlet weak var rewindBtn: UILabel!
    @IBOutlet weak var changeSideBtn: UILabel!
    @IBOutlet weak var lStatus: UILabel!
    @IBOutlet weak var rStatus: UILabel!
    @IBOutlet weak var resetBtn: UILabel!
    
    let status = "Serve"
    var ballCount = 0
    var deuceType = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化設定
        initFunc()
        
        // Enable User Interaction 互動
        lScore.isUserInteractionEnabled = true
        // Add Tap Gesture Recognizer 點擊手勢識別器
        let lScoreTap = UITapGestureRecognizer(target: self, action: #selector(self.clickLeftGame(_:)))
        lScore.addGestureRecognizer(lScoreTap)
        
        rScore.isUserInteractionEnabled = true
        let rScoreTap = UITapGestureRecognizer(target: self, action: #selector(self.clickRightGame(_:)))
        rScore.addGestureRecognizer(rScoreTap)
        
        let rewind = UITapGestureRecognizer(target: self, action: #selector(self.clickRewind(_:)))
        rewindBtn.isUserInteractionEnabled = true
        rewindBtn.addGestureRecognizer(rewind)
        
        let changeSide = UITapGestureRecognizer(target: self, action: #selector(self.clickChangeSide(_:)))
        changeSideBtn.isUserInteractionEnabled = true
        changeSideBtn.addGestureRecognizer(changeSide)
        
        let reset = UITapGestureRecognizer(target: self, action: #selector(self.clickReset(_:)))
        resetBtn.isUserInteractionEnabled = true
        resetBtn.addGestureRecognizer(reset)
        
    }

    func initFunc() {
//        print("init")
        // 初始設定左邊發球
        view.backgroundColor = UIColor(named: "leftBg")
        lStatus.text = status
        rStatus.text = ""
        lGame.text = "0"
        rGame.text = "0"
        lScore.text = "0"
        rScore.text = "0"
        ballCount = 0
        deuceType = false
    }
    
    @objc func clickReset(_ sender: UITapGestureRecognizer) {
        initFunc()
    }
    
    @objc func clickLeftGame(_ sender: UITapGestureRecognizer){
        ballCount += 1
        let point = Int(lScore.text!) ?? 0
        lScore.text = "\(point + 1)"
        addLeftScoreRegister(at: point)
        addCountRegister(at: ballCount)
        addGameScore()
        serve()
    }
    
    @objc func clickRightGame(_ sender: UITapGestureRecognizer){
        ballCount += 1
        let point = Int(rScore.text!) ?? 0
        rScore.text = "\(point + 1)"
        addRightScoreRegister(at: point)
        addCountRegister(at: ballCount)
        addGameScore()
        serve()
    }
    
    // 其中一方達到 11 分時獲勝，上方獲勝的局數更新
//    在一局比賽中首先發球的一方，在該場比賽的下一局中應首先接發球
    func addGameScore(){
        if !deuceType {
            if lScore.text == "11" {
                lGame.text = "\((Int(lGame.text!) ?? 0) + 1)"
                
                lScore.text = "0"
                rScore.text = "0"
                serveSide()
                ballCount = 0
            } else if rScore.text == "11" {
                rGame.text = "\((Int(rGame.text!) ?? 0) + 1)"
                
                lScore.text = "0"
                rScore.text = "0"
                serveSide()
                ballCount = 0
            } else if lScore.text == "10" && rScore.text == "10" {
//                print("deuce 10 : 10")
                deuceType = true
            }
        } else {
//            print("deuce func")
            deuceBall()
        }
        
    }
    
    // 發球改成每 1 球輪替一次，先多得 2 分的獲勝
    func deuceBall() {
        print("deuceBall")
        serveOne()
        let leftDeuce = Int(lScore.text!)
        let rightDeuce = Int(rScore.text!)
        let difference = leftDeuce! - rightDeuce!
        
        // left win
        if difference == 2 {
            let controller = UIAlertController(title: "Game Set", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            lGame.text = "\((Int(lGame.text!) ?? 0) + 1)"
            serveSide()
            rScore.text = "0"
            lScore.text = "0"
            ballCount = 0
            deuceType = false
        } else if difference == -2 {
            let controller = UIAlertController(title: "Game Set", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            rGame.text = "\((Int(rGame.text!) ?? 0) + 1)"
            serveSide()
            lScore.text = "0"
            rScore.text = "0"
            ballCount = 0
            deuceType = false
        }
        
    }
    
    // 發球時每 2 球輪替一次
    func serve() {
        if ballCount == 2 {
            if lStatus.text == status {
                let leftStatus = status
                addLeftStatusRegister(at: leftStatus)
                rBackGround()
            } else if rStatus.text == status {
                let rightStatus = status
                addRightStatusRegister(at: rightStatus)
                lBackGround()
            }
            ballCount = 0
        }
    }
    
    // 發球時每 1 球輪替一次
    func serveOne() {
        print("發球時每 1 球輪替一次")
        if ballCount == 1 {
            if lStatus.text == status {
                let leftStatus = status
                addLeftStatusRegister(at: leftStatus)
                rBackGround()
            } else if rStatus.text == status {
                let rightStatus = status
                addRightStatusRegister(at: rightStatus)
                lBackGround()
            }
            ballCount = 0
        }
    }
    
    func rBackGround() {
        view.backgroundColor = UIColor(named: "rightBg")
        rStatus.text = status
        lStatus.text = ""
    }
    
    func lBackGround() {
        view.backgroundColor = UIColor(named: "leftBg")
        lStatus.text = status
        rStatus.text = ""
    }
    
    // 發球局判斷
    func serveSide() {
        let number = (Int(lGame.text!) ?? 0) + (Int(rGame.text!) ?? 0)
        let result = number % 2
        // 餘數=0 左邊發球
        if result == 0 {
            lBackGround()
        } else {
            rBackGround()
        }
    }
    
    
    @objc func clickRewind(_ sender: UITapGestureRecognizer){
        self.undoManager?.undo()
    }
    
    func addLeftScoreRegister(at lscore: Int) {
        self.undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.undoLeftScore(at: lscore)
        })
    }
    
    func undoLeftScore(at lscore: Int) {
        print("lscore : \(lscore)")
        lScore.text = "\(lscore)"
    }
    
    func addRightScoreRegister(at rscore: Int) {
        self.undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.undoRightScore(at: rscore)
        })
    }
    
    func undoRightScore(at rscore: Int) {
        print("rscore : \(rscore)")
        rScore.text = "\(rscore)"
    }
    
    func addCountRegister(at count: Int) {
        self.undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.undoCount(at: count)
        })
    }
    
    func undoCount(at count: Int) {
//        print("undoCount : \(count)")
        ballCount = count - 1
//        print("ballCount : \(ballCount)")
    }
    
    func addLeftStatusRegister(at lstatus: String) {
        self.undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.undoLeftStatus(at: lstatus)
        })
    }
    
    func undoLeftStatus(at lstatus: String) {
        lBackGround()
    }
    
    func addRightStatusRegister(at rstatus: String) {
        self.undoManager?.registerUndo(withTarget: self, handler: { (selfTarget) in
            selfTarget.undoRightStatus(at: rstatus)
        })
    }
    
    func undoRightStatus(at rstatus: String) {
        rBackGround()
    }
    

    @objc func clickChangeSide(_ sender: UITapGestureRecognizer){
        changeSide()
    }
    
    // 左邊的分數跑到右邊，右邊的分數跑到左邊
    func changeSide(){
        let leftLarge = lGame.text
        let rightLarge = rGame.text
        let leftSmall = lScore.text
        let rightSmall = rScore.text
        
        lGame.text = rightLarge
        rGame.text = leftLarge
        lScore.text = rightSmall
        rScore.text = leftSmall

        serveSide()
    }
    
    
    
    
}

