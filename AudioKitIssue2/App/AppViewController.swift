//  Copyright © 2019 Learnfield. All rights reserved.

import UIKit
import AudioKit

class AppViewController: UIViewController {

    /// The main output amplitude tracker
    private let masterMeter = AKAmplitudeTracker()
    
    /// The main output mixer (after the amplitude tracker)
    private let masterMixer = AKMixer()
    
    /// One random player
    private let player = AKPlayer()
    
    /// Invoked once layout is finished and view is visible
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAudioKit()
    }

    /// Audiokit faulty example
    func setupAudioKit() {
        // session settings
        AKAudioFile.cleanTempDirectory()
        AKSettings.bufferLength = .long
        AKSettings.playbackWhileMuted = true
        #if DEBUG
        AKSettings.enableLogging = true
        #endif
        do {
            try AKSettings.setSession(category: .playback, with: .mixWithOthers)
        } catch {
            print("error")
        }
        // create top level meter, mixer and connect them
        self.masterMixer >>> self.masterMeter
        //AudioKit.engine = AVAudioEngine()
        AudioKit.output = self.masterMeter
        // start audiokit
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        /// Add player
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addPlayer()
        }
    }
    
    /// Add player
    func addPlayer() {
        try? player.load(url: Bundle.main.url(forResource: "A1", withExtension: "wav")!)
        player.prepare()
        player.detach()
        player.connect(to: masterMeter)
        /// Trigger play
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playSound()
        }
    }
    
    /// Play sound
    func playSound() {
        /// Add player
        player.play()
    }

}
