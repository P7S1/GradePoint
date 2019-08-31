//
//  howItWorksViewController.swift
//  GradePoint
//
//  Created by Atemnkeng Fontem on 8/2/19.
//  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import GoogleMobileAds

class howItWorksViewController: UIViewController,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate {
    @IBOutlet weak var cardOutlet: UICollectionView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var exitButton: UIButton!
    var cards : [howItWorksCard] = [howItWorksCard]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bannerView.adUnitID = "ca-app-pub-7404153809143887/2785430968"
        //vca-app-pub-7404153809143887/2785430968
        bannerView.rootViewController = self
        NotificationCenter.default.addObserver(self, selector: #selector(unDimScreen), name:NSNotification.Name(rawValue: "unDimScreen"), object: nil)

        
       cardOutlet.dataSource = self
        cardOutlet.delegate = self
        initCards()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
     @objc func unDimScreen(){
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
    }
    func initCards(){
        
        let c1 = howItWorksCard()
        //red
        c1.initCard(i: UIImage(named: "c1")!, c: UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 0.7).cgColor, t: "Most American schools use the 4.0 grading format, in which letter grades are converted into values")
        cards.append(c1)
        
        let c2 = howItWorksCard()
        //green
        c2.initCard(i: UIImage(named: "c2")!, c: UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.7).cgColor, t: "For most schools, those standard values are A = 4.0, B = 3.0, C = 2.0, D = 1.0, and F = 0 ")
        cards.append(c2)
        
        let c3 = howItWorksCard()
        //blue
        c3.initCard(i: UIImage(named: "c3")!, c: UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.7).cgColor, t: "This app works by totaling all the corresponding values for each letter grade, then dividing that by the total number of credits ")
        cards.append(c3)
        //purple
        let c4 = howItWorksCard()
        c4.initCard(i: UIImage(named: "c4")!, c: UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 0.7).cgColor, t: "That's how GPA is calculated! just remember: letter value sum / points value sum = GPA")
        cards.append(c4)
        //indigo
        let c5 = howItWorksCard()
        c5.initCard(i: UIImage(named: "c5")!, c: UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 0.7).cgColor, t: "Some higher level classes such as Honors or AP have special weights to them due to the increased difficulty of the course. Those weights can vary depending on the difficulty of the course.")
        cards.append(c5)
        //pink
        let c6 = howItWorksCard()
        c6.initCard(i: UIImage(named: "c6")!, c: UIColor(red: 1, green: 45/255, blue: 85/255, alpha: 0.7).cgColor, t: "Weights make corresponding letter values  higher than the standard. For example, an A in a standard weight class is 4.0 but an A in a Honors class is 4.5")
        cards.append(c6)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! howItWorksCollectionViewCell
        
        cell.backgroundImage.image = cards[indexPath.item].backgroundImage
        cell.backgroundShade.backgroundColor = UIColor(cgColor: cards[indexPath.item].backgroundColor)
        cell.cellText.text = cards[indexPath.item].text

        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 1.0
        
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.cardOutlet.scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.cardOutlet.scrollToNearestVisibleCollectionViewCell()
        }
    }
    

    
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    
}
