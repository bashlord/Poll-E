//
//  PVC_PollViews.swift
//  Poll-E
//
//  Created by John Jin Woong Kim on 10/11/16.
//  Copyright © 2016 John Jin Woong Kim. All rights reserved.
//

import UIKit

class PVC_PollViews: UIPageViewController {
    
    weak var pvc_delegate:PVC_PollViewsDelegate?
    
    //holds indexes of answered polls and unanswered polls
    var answered = [Int]()
    var unanswered = [Int]()
    //not going to make an entire array of viewcontrollers, since thats dumb
    //and would waste alot of mem
    //holds indexes of answered/unanswered polls
    var curr_a = 0
    var curr_una = 0
    var curr_all = 0
    
    var emptyVC:VC_Text!
    
    //filter flag
    // 0 = show all
    // 1 = show unanswered 
    // 2 = show answered
    var unansweredflag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyVC = self.storyboard?.instantiateViewController(withIdentifier: "emptyVC") as! VC_Text

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource = self
        delegate = self

        if self.answered.count != (UIApplication.shared.delegate as! AppDelegate).answered.count{
            self.answered.removeAll()
            self.answered.append(contentsOf: (UIApplication.shared.delegate as! AppDelegate).answered)
        }
        if self.unanswered.count != (UIApplication.shared.delegate as! AppDelegate).unanswered.count{
            self.unanswered.removeAll()
            self.unanswered.append(contentsOf: (UIApplication.shared.delegate as! AppDelegate).unanswered)
        }
        if unansweredflag == 0{
            if (UIApplication.shared.delegate as! AppDelegate).Q.count > 0{
                let firstViewController = [VC_Q(curr_all)]
                self.setViewControllers(firstViewController, direction: .forward, animated: true, completion: nil)
                //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: (UIApplication.shared.delegate as! AppDelegate).Q.count)
                scrollToViewControllerp(firstViewController[0], direction: .forward)
            }
        }else if unansweredflag == 1{
            if unanswered.count > 0{
                let firstViewController = [VC_Q(curr_una)]
                self.setViewControllers(firstViewController, direction: .forward, animated: true, completion: nil)
            
            
            //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: unanswered.count)
                scrollToViewControllerp(firstViewController[0], direction: .forward)
            }
        }else{
            if answered.count > 0{
                let firstViewController = [VC_Q(curr_a)]
                self.setViewControllers(firstViewController, direction: .forward, animated: true, completion: nil)
            
            //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: answered.count)
                 scrollToViewControllerp(firstViewController[0], direction: .forward)
            }
        }
    }
    
        func scrollToNextViewController() {
                var nextViewController: VC_Question!
            if unansweredflag == 0{
                if curr_all+1 < (UIApplication.shared.delegate as! AppDelegate).Q.count{
                    nextViewController = VC_Q(curr_all+1)
                    curr_all += 1
                    scrollToViewControllerp(nextViewController!,direction: .forward)
                }
            }else if unansweredflag == 1{
                if curr_una+1 < unanswered.count{
                    nextViewController = VC_Q(curr_una+1)
                    curr_una += 1
                    scrollToViewControllerp(nextViewController!,direction: .forward)
                }
            }else{
                if curr_a+1 < answered.count{
                    nextViewController = VC_Q(curr_a+1)
                    curr_a += 1
                    scrollToViewControllerp(nextViewController!,direction: .forward )
                }
            }
            

        }
    
    func scrollToPrevViewController() {
            var nextViewController: VC_Question!
        if unansweredflag == 0{
            if (UIApplication.shared.delegate as! AppDelegate).Q.count > 0 && curr_all > 0{
                nextViewController = VC_Q(curr_all-1)
                curr_all -= 1
                scrollToViewControllerp(nextViewController!,direction: .reverse)
            }
        }else if unansweredflag == 1{
                if unanswered.count > 0 && curr_una > 0{
                    nextViewController = VC_Q(curr_una-1)
                    curr_una -= 1
                    scrollToViewControllerp(nextViewController!, direction: .reverse)
                }
            }else{
                if answered.count > 0 && curr_a > 0{
                    nextViewController = VC_Q(curr_a-1)
                    curr_a -= 1
                    scrollToViewControllerp(nextViewController!,direction: .reverse)
                }
            }
    }

    
        func scrollToViewController(index newIndex: Int) {
            if unansweredflag == 0{
                let currentIndex = curr_all
                let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
                let nextViewController = VC_Q(newIndex)
                scrollToViewControllerp(nextViewController, direction: direction)
            }else if unansweredflag == 1{
                let currentIndex = curr_una
                let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
                let nextViewController = VC_Q(newIndex)
                scrollToViewControllerp(nextViewController, direction: direction)
            }else{
                let currentIndex = curr_a
                let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
                let nextViewController = VC_Q(newIndex)
                scrollToViewControllerp(nextViewController, direction: direction)
            }
        }
        
        func scrollToViewControllerp(_ viewController: UIViewController,
            direction: UIPageViewControllerNavigationDirection) {
                setViewControllers([viewController],
                    direction: direction,
                    animated: true,
                    completion: { (finished) -> Void in
                        self.notifyTutorialDelegateOfNewIndex()
                })
        }
        
        func notifyTutorialDelegateOfNewIndex() {
            var index = -1
            if unansweredflag == 0{
                if (UIApplication.shared.delegate as! AppDelegate).Q.count > 0{
                    index = curr_all
                    pvc_delegate?.pvc_PollViews(self,
                        didUpdatePageIndex: index)
                }
            }else if unansweredflag == 1{
                if unanswered.count > 0{
                    index = curr_una
                    pvc_delegate?.pvc_PollViews(self,
                        didUpdatePageIndex: index)
                }
            }else{
                if answered.count > 0{
                    index = curr_a
                    pvc_delegate?.pvc_PollViews(self,
                        didUpdatePageIndex: index)
                }
            }
        }
    
    func togglePVC(_ flag: Int){
        if unansweredflag == 0{
            if (UIApplication.shared.delegate as! AppDelegate).Q.count > 0{
                scrollToViewControllerp(VC_Q(curr_all), direction: .forward)
            }else{
                emptyVC.msg = "No more questions :("
                scrollToViewControllerp(emptyVC, direction: .forward)
            }
        }else if unansweredflag == 1{
            if unanswered.count > 0{
                scrollToViewControllerp(VC_Q(curr_una), direction: .forward)
            }else{
                emptyVC.msg = "No more unanswered questions :("
                scrollToViewControllerp(emptyVC, direction: .forward)
            }
        }else{
            if answered.count > 0{
                scrollToViewControllerp(VC_Q(curr_a), direction: .forward)
            }else{
                emptyVC.msg = "No more answered questions :("
                scrollToViewControllerp(emptyVC, direction: .forward)
            }
        }
    
    }
    
    fileprivate func VC_Q(_ index:Int) -> VC_Question {
        let ret = (self.storyboard?.instantiateViewController(withIdentifier: "a_poll"))! as! VC_Question
        if unansweredflag == 0{
            print("Current filter: All - Creating poll for index " + String(index))
            let poll = (UIApplication.shared.delegate as! AppDelegate).Q[index]
            if poll?.resp == -1{
                for(i in 0 ..< unanswered.count){
                    if unanswered[i] == poll?.id{
                        ret.unans_index = i
                        break
                    }
                }
                poll?.isUna = true
            }else{
                poll?.isUna = false
            }
             poll?.index = index
            ret.poll = poll!
        }else if unansweredflag == 1{
            let unan = unanswered[index]
            let poll = (UIApplication.shared.delegate as! AppDelegate).Q[ unan ]
            poll?.index = unan
            poll?.isUna = true
            ret.unans_index = index
            ret.poll = poll!
        }else{
            let an = answered[index]
            let poll = (UIApplication.shared.delegate as! AppDelegate).Q[ an ]
            poll?.index = index
            poll?.isUna = false
            ret.poll = poll!

            ret.poll = poll!
        }
        return ret
    }
}

// MARK: UIPageViewControllerDataSource

extension PVC_PollViews: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            if unansweredflag == 0{
                let previousIndex = curr_all - 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard (UIApplication.shared.delegate as! AppDelegate).Q.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewController(withIdentifier: "a_poll"))! as! VC_Question
                let poll = (UIApplication.shared.delegate as! AppDelegate).Q[previousIndex]
                ret.poll = poll
                curr_all -= 1
                return ret
            }else if unansweredflag == 1{//if showing unanswered polls
                let previousIndex = curr_una - 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewController(withIdentifier: "a_poll"))! as! VC_Question
                let unan = unanswered[previousIndex]
                let poll = (UIApplication.shared.delegate as! AppDelegate).Q[unan]
                ret.poll = poll
                curr_una -= 1
                return ret
            }else{//if showing answered polls
                let previousIndex = curr_a - 1
            
                guard previousIndex >= 0 else {
                    return nil
                }
            
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewController(withIdentifier: "a_poll"))! as! VC_Question
                let an = answered[previousIndex]
                let poll = (UIApplication.shared.delegate as! AppDelegate).Q[an]
                ret.poll = poll
                curr_a -= 1
                return ret
            }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
            if unansweredflag == 0{
                let previousIndex = curr_all + 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard (UIApplication.shared.delegate as! AppDelegate).Q.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewController(withIdentifier: "a_poll"))! as! VC_Question
                let poll = (UIApplication.shared.delegate as! AppDelegate).Q[previousIndex]
                ret.poll = poll
                curr_all += 1
                return ret
            }else if unansweredflag == 1{//if showing unanswered polls
                let previousIndex = curr_una + 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewController(withIdentifier: "a_poll"))! as! VC_Question
                let unan = unanswered[previousIndex]
                let poll = (UIApplication.shared.delegate as! AppDelegate).Q[unan]
                ret.poll = poll
                curr_una += 1
                return ret
            }else{//if showing answered polls
                let previousIndex = curr_a + 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewController(withIdentifier: "a_poll"))! as! VC_Question
                let an = answered[previousIndex]
                let poll = (UIApplication.shared.delegate as! AppDelegate).Q[an]
                ret.poll = poll
                curr_a += 1
                return ret
            }
    }
}

extension PVC_PollViews: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            self.notifyTutorialDelegateOfNewIndex()
            
    }
    
}

protocol PVC_PollViewsDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func pvc_PollViews(_ tutorialPageViewController: PVC_PollViews,
        didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func pvc_PollViews(_ tutorialPageViewController:PVC_PollViews,
        didUpdatePageIndex index: Int)
    
}
