//
//  ViewController.swift
//  myRecording
//
//  Created by 覃子轩 on 2017/1/12.
//  Copyright © 2017年 覃子轩. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tapButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    ////定义音频的编码参数，这部分比较重要，决定录制音频文件的格式、音质、容量大小等，建议采用AAC的编码方式
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//音频质量
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.uiInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: recordSettings)//初始化实例
            audioRecorder.prepareToRecord()//准备录音
        } catch {
        }
        
        self.uiAction()
    }
    
    private func uiInit() {
        self.tapButton.layer.masksToBounds = true
        self.tapButton.layer.cornerRadius = self.tapButton.frame.size.width/2
    }
    
    private func uiAction() {
        self.tapButton.addTarget(self, action: #selector(tapAction(_ :)), for:.touchDown)
        self.tapButton.addTarget(self, action: #selector(tapAction(_ :)), for: .touchUpInside)
        self.tapButton.addTarget(self, action: #selector(tapAction(_ :)), for: .touchUpOutside)
    }
    
    var testState = 0
    
    func tapAction(_ button:UIButton) {
        switch testState {
        case 0:
            print("play animation")
            self.showAnimation()
            self.startRecordAction()
            self.testState = 1
        case 1:
            print("close animation")
            self.testState = 0
            self.tapButton.layer.removeAllAnimations()
            self.stopRecordAction()
        default:
            print("error")
        }
    }
    private func showAnimation() {
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat,.autoreverse,.curveEaseInOut], animations: { 
            self.tapButton.alpha = 0
            }) { (finish) in
                if !finish {
                    self.tapButton.alpha = 1
                    return
                }
        }
    }
    
    func directoryURL() -> NSURL? {
        //定义并构建一个url来保存音频，音频文件名为ddMMyyyyHHmmss.caf
        //根据时间来设置存储文件名
        let currentDateTime = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "你好"
        let recordingName = formatter.string(from: currentDateTime as Date)+".caf"
        print(recordingName)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)
        
        return soundURL as NSURL?
    }
    
    @IBAction func startRecord(sender: AnyObject) {
        
    }
    
    private func startRecordAction() {
        //开始录音
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                print("record!")
            } catch {
            }
        }
    }
    
    private func stopRecordAction() {
        //停止录音
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
            print("stop!!")
        } catch {
        }
    }
    
    @IBAction func stopRecord(sender: AnyObject) {
        
    }
    
    
    @IBAction func startPlaying(sender: AnyObject) {
        //开始播放
        if (!audioRecorder.isRecording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
                audioPlayer.play()
                print("play!!")
            } catch {
            }
        }
    }
    
    
    @IBAction func pausePlaying(sender: AnyObject) {
        //暂停播放
        if (!audioRecorder.isRecording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
                audioPlayer.pause()
                
                print("pause!!")
            } catch {
            }
        }
        
    }
}

