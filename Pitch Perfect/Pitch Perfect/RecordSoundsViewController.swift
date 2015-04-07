//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lee Tang on 3/29/15.
//  Copyright (c) 2015 com.Tang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var instructionToRecord: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
   
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        //hide stop button and enable record button
        stopButton.hidden = true
        recordButton.enabled = true
        instructionToRecord.hidden = false
        recordingInProgress.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //disable record button
        recordButton.enabled = false
        //show stop button
        stopButton.hidden = false
        //show text to say 'recording'
        recordingInProgress.hidden = false
        //hide instructions
        instructionToRecord.hidden = true
        //show pause button
        pauseButton.hidden = false
        
        //record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //Save recorded audio
            //calling Recorded Audio
            let recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
            //Move to the next scene via perform segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            instructionToRecord.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        //disable record button
        recordButton.enabled = false
        //show stop button
        stopButton.hidden = false
        //hide text to say 'recording'
        recordingInProgress.hidden = true
        //hide instructions
        instructionToRecord.hidden = true
        //show resume button
        resumeButton.hidden = false
        //hide pause button
        pauseButton.hidden = true
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        //disable record button
        recordButton.enabled = false
        //show stop button
        stopButton.hidden = false
        //show text to say 'recording'
        recordingInProgress.hidden = false
        //hide instructions
        instructionToRecord.hidden = true
        //show pause button
        pauseButton.hidden = false
        pauseButton.enabled = true
        resumeButton.hidden = true
        
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        //clear "recording" text
        recordingInProgress.hidden = true
        //stop recording user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}

