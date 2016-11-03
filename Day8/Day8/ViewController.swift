//
//  ViewController.swift
//  Day8
//
//  Created by Hoang Doan on 10/30/16.
//  Copyright © 2016 Hoang Doan. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var playerBar: UIView!
    @IBOutlet weak var playerSongImage: UIImageView!
    @IBOutlet weak var playerSongName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var notigication: UILabel!
    
    @IBAction func playAction(_ sender: AnyObject) {
        if player.rate == 1.0 {
            player.pause()
            playButton.setBackgroundImage(UIImage(named: "Play-50"), for: .normal)
        } else {
            playButton.setBackgroundImage(UIImage(named: "Pause-50"), for: .normal)
            player.play()
        }
        
    }
    
    @IBAction func nextAction(_ sender: AnyObject) {
        self.currentIndex += 1
        if self.currentIndex == (self.tableData.count) {
            self.currentIndex = 0
            
        }
        
        self.playerBar.isHidden = false
        let imageUrl = URL(string: tableData[currentIndex].artworkUrl)
        self.playerSongImage.sd_setImage(with: imageUrl)
        
        self.playerSongName.text = tableData[currentIndex].trackCensoredName
        
        let url = self.tableData[currentIndex].previewUrl
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.play()
        playButton.setBackgroundImage(UIImage(named: "Pause-50"), for: .normal)
        forwardButton.setBackgroundImage(UIImage(named: "Fast Forward-50"), for: .normal)
        
    }
    
    @IBOutlet weak var songListView: UITableView!

    @IBOutlet weak var searchBox: UITextField!

    var spinnerActivity = MBProgressHUD()
    
    var player = AVPlayer()
    
    var currentIndex = 0

    @IBAction func printSearch(_ sender: AnyObject) {
        let searchInput = searchBox.text!.replacingOccurrences(of: " ", with: "+")
        self.requestItunesTop10Song(songName: searchInput)
        spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Searching";
        spinnerActivity.isUserInteractionEnabled = false;
        self.logo.isHidden = true
        self.notigication.isHidden = true
        player.pause()
    }
    
    var tableData: [SongEnity] = [SongEnity]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBox.delegate = self
        self.searchBox.placeholder = "Tìm kiếm bài hát"
        self.searchBox.returnKeyType = .search
        self.songListView.delegate = self
        self.songListView.dataSource = self
        self.songListView.isHidden = true
        self.playerBar.isHidden = true
        self.playButton.setBackgroundImage(UIImage(named: "Play-50"), for: .normal)
        self.forwardButton.setBackgroundImage(UIImage(named: "Fast Forward-50"), for: .normal)
        
        let urlImage = URL(string: "http://www.androidpolice.com/wp-content/uploads/2015/09/nexus2cee_image10.png");
        self.logo.sd_setImage(with: urlImage)
        
        self.notigication.isHidden = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func requestItunesTop10Song(songName: String) {
        let stringUrl = "https://itunes.apple.com/search?term=" + songName
        Alamofire.request(stringUrl).responseJSON { response in
            
            if let JSON = response.result.value {
                guard let entry = JSON as? [String: AnyObject] else {
                    return
                }
                
                guard let allSongs = entry["results"] as? [AnyObject] else {
                    return
                }
                
                self.tableData.removeAll()
                
                
                if allSongs.count == 0 {
                    DispatchQueue.main.async {
                        self.reloadData()
                        self.spinnerActivity.hide(animated: true);
                        self.songListView.isHidden = true
                        self.playerBar.isHidden = true
                        self.notigication.isHidden = false
                    }
                } else {
                    for song in allSongs {
                        
                        guard let kind = song["kind"] as? String else {
                            return
                        }
                        
                        if kind == "song" {
                            guard let trackName = song["trackCensoredName"] as? String else {
                                return
                            }
                            
                            
                            guard let artistName = song["artistName"] as? String else {
                                return
                            }
                            
                            
                            guard let artworkUrl = song["artworkUrl60"] as? String else {
                                return
                            }
                            
                            
                            
                            guard let price = song["trackPrice"] as? Float else {
                                return
                            }
                            
                            guard let previewUrl = song["previewUrl"] as? String else {
                                return
                            }
                            
                            
                            let songItem = SongEnity(trackCensoredName: trackName, artworkUrl: artworkUrl, artistName: artistName, trackPrice: price, preview: previewUrl)
                            
                            self.tableData.append(songItem)
                        }
                        
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.reloadData()
                        self.spinnerActivity.hide(animated: true);
                        self.songListView.isHidden = false
                        
                    }

                }
                
                
            }
            

            
        }
    }
    
    
    
    func reloadData() {
        self.songListView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.playerBar.isHidden = false
        let imageUrl = URL(string: tableData[indexPath.row].artworkUrl)
        self.playerSongImage.sd_setImage(with: imageUrl)
        
        self.playerSongName.text = tableData[indexPath.row].trackCensoredName
        self.currentIndex = indexPath.row
        
        let url = self.tableData[indexPath.row].previewUrl
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.play()
        playButton.setBackgroundImage(UIImage(named: "Pause-50"), for: .normal)
        forwardButton.setBackgroundImage(UIImage(named: "Fast Forward-50"), for: .normal)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = songListView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        let songName = cell.contentView.viewWithTag(2) as! UILabel
        songName.text = tableData[indexPath.row].trackCensoredName
        
        let artistName = cell.contentView.viewWithTag(3) as! UILabel
        artistName.text = tableData[indexPath.row].artistName
        
        let priceButton = cell.contentView.viewWithTag(4) as! UIButton
        
        priceButton.layer.masksToBounds = true
        priceButton.layer.borderWidth = 1
        priceButton.layer.borderColor = priceButton.tintColor.cgColor
        priceButton.layer.cornerRadius = priceButton.frame.width/250
        
        priceButton.setTitle("USD " + tableData[indexPath.row].trackPrice.description, for: .normal)

        
        let artwork = cell.contentView.viewWithTag(1) as! UIImageView
        
        let imageUrl = URL(string: tableData[indexPath.row].artworkUrl)
        
        artwork.sd_setImage(with: imageUrl)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

