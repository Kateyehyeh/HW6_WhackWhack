//
//  ViewController.swift
//  HW6_WhackWhack
//
//  Created by Kateyeh on 2025/2/18.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var gopherButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    //生成一個背景音樂播放器元件，後續要增加背景音樂用
    let backgroundPlayer = AVPlayer()
    //生成一個播放器元件，後續要增加音效用
    let player = AVPlayer()
    //設定一個計時器：Timer變數
    var countdownTimer: Timer?
    //遊戲時間預設倒數30秒
    var gameDuration = 30
    //點擊得分預設為0
    var tapScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //遊戲初始狀態
        resetGame()
        
        //加入背景音樂
        let backgroundMusicUrl = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a")!
        let backgroundMusicPlayerItem = AVPlayerItem(url: backgroundMusicUrl)
        backgroundPlayer.replaceCurrentItem(with: backgroundMusicPlayerItem)
        backgroundPlayer.volume = 0.3
        backgroundPlayer.play()
    }
    
    //遊戲開始
    @IBAction func startGame(_ sender: UIButton) {
        //遊戲開始後，START按鈕會消失
        startLabel.isHidden = true
        startButton.isHidden = true
        //遊戲開始後，地鼠按鈕可以按了
        gopherButton.isEnabled = true
        
        //倒數計時
        //啟動計時器，每1秒執行一次
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)  { Timer in
            //不加等於，會多跑一次變負1
            if self.gameDuration > 0 {
                //秒數減1
                self.gameDuration -= 1
                //更新標籤的數字
                self.timerLabel.text = "\(self.gameDuration)"
            } else {
                self.endgameAlert()
            }
        }
    }
    
    //擊打地鼠
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        //每擊打一次增加一分
        tapScore += 1
        //把擊打得分顯示在畫面的Score裡
        scoreLabel.text = "\(tapScore)"
        
        
        //錘子動畫
        let tapLocation = sender.location(in: view)
        showIcon(at: tapLocation)
        
        //擊打音效
        let whackUrl = Bundle.main.url(forResource: "whack", withExtension: "m4a")!
        let playItem = AVPlayerItem(url: whackUrl)
        player.replaceCurrentItem(with: playItem)
        player.volume = 1
        player.play()
        
    }
    
    func showIcon(at position: CGPoint) {
        let icon = UIImageView(image: UIImage(named: "gavel"))
        let iconSize: CGFloat = 100 // 你設置圖示的大小
        icon.frame = CGRect(x: position.x - iconSize/2, y: position.y - iconSize/2, width: 100, height: 100)
        view.addSubview(icon)
        
        //錘子動畫
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            //錘子透明度變為0(淡出畫面)
            icon.alpha = 0
            //設定旋轉後錘子變小消失的動畫，逆時針旋轉20度
            icon.transform = CGAffineTransform(scaleX: 0.5, y: 0.5).rotated(by: -1 * .pi / 9)
        }
        
        //動畫結束後錘子圖消失
        animator.addCompletion { position in
            if position == .end {  // 確保動畫到結束時才移除
                icon.removeFromSuperview()
            }
        }

        animator.startAnimation()
       
    }
    
    
    //重新開始
    @IBAction func resetButton(_ sender: Any) {
        resetGame()
    }
    
    func resetGame() {
        //遊戲結束，停止計時器
        countdownTimer?.invalidate()
        //畫面開始的預設秒數(30秒)
        gameDuration = 30
        timerLabel.text = "\(gameDuration)"
        //畫面開始的預設分數(0分)
        tapScore = 0
        scoreLabel.text = "\(tapScore)"
        //遊戲開始前，地鼠按鈕還不可以按
        gopherButton.isEnabled = false
        //預設START按鈕是顯示的，並設定成圓角形狀
        startLabel.isHidden = false
        startLabel.layer.cornerRadius = 20
        startLabel.layer.masksToBounds = true
        startButton.isHidden = false
        //設定RESET按鈕為圓角形狀
        resetLabel.layer.cornerRadius = 20
        resetLabel.layer.masksToBounds = true
    }
    
    
    //遊戲結束視窗
    func endgameAlert() {
        //遊戲結束，停止計時器
        countdownTimer?.invalidate()
        //停用按鈕，點按鈕不會增加得分
        gopherButton.isEnabled = false
        
        //建立UIAlertController，遊戲分數結算視窗
        let endMessage = UIAlertController(title: "Game Over.", message: "You scored \(tapScore) points！🥳", preferredStyle: .alert)
        //新增“再玩一次”按鈕
        let playAgainAction = UIAlertAction(title: "Play Again", style: .default)
        endMessage.addAction(playAgainAction)
        //顯示彈出視窗
        present(endMessage, animated: true)
        
        //回歸原始設定
        resetGame()
    }
}



