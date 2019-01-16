//
//  ScrollableBottomSheetViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 14/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

protocol AddAnnotationsDelegate {
    func addAnnotations(location: Location)
}

class ScrollableBottomSheetViewController: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var locationsMarkedTableView: UITableView!
    
    //MARK: - Properties
    var addAnnotationsDelegate: AddAnnotationsDelegate!
    var locations = Location.all
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 150
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

       locationsMarkedTableView.register(UINib(nibName: "MarkedLocationTableViewCell", bundle: nil), forCellReuseIdentifier: MarkedLocationTableViewCell.identifier)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ScrollableBottomSheetViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locations = Location.all
        locationsMarkedTableView.reloadData()
        prepareBackgroundView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
        })
    }
    
    //MARK: - Methods
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }

        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )

            duration = duration > 1.3 ? 1 : duration

            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }

            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.locationsMarkedTableView.isScrollEnabled = true
                }
            })
        }
    }

    private func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .regular)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }

    private func saveContext() {
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
}

extension ScrollableBottomSheetViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Hit the 'ADD ON MAP' button to add a location in your location list!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = locationsMarkedTableView.dequeueReusableCell(withIdentifier: MarkedLocationTableViewCell.identifier, for: indexPath) as? MarkedLocationTableViewCell else {
            return UITableViewCell()
        }
        
        let location = locations[indexPath.row]
    
        cell.selectionStyle = .none
        cell.location = location
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDelegate.viewContext.delete(locations[indexPath.row])
            locations.remove(at: indexPath.row)
            saveContext()
            locationsMarkedTableView.beginUpdates()
            locationsMarkedTableView.deleteRows(at: [indexPath], with: .automatic)
            locationsMarkedTableView.endUpdates()
        }
    }
}

extension ScrollableBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return locations.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addAnnotationsDelegate.addAnnotations(location: locations[indexPath.row])
    }
}

extension ScrollableBottomSheetViewController: UIGestureRecognizerDelegate {

    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
        if (y == fullView && locationsMarkedTableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            locationsMarkedTableView.isScrollEnabled = false
        } else {
            locationsMarkedTableView.isScrollEnabled = true
        }
        return false
    }
}
