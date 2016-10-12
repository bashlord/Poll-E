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
    var unansweredflag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answered.appendContentsOf((UIApplication.sharedApplication().delegate as! AppDelegate).answered)
        self.unanswered.appendContentsOf((UIApplication.sharedApplication().delegate as! AppDelegate).unanswered)
        dataSource = self
        delegate = self
        let firstViewController = [VC_Q(curr_una)]
        self.setViewControllers(firstViewController, direction: .Forward, animated: true, completion: nil)
        
        //set delegate for poll counts and updating
        pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: unanswered.count)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.answered.count != (UIApplication.sharedApplication().delegate as! AppDelegate).answered.count{
            self.answered.removeAll()
            self.answered.appendContentsOf((UIApplication.sharedApplication().delegate as! AppDelegate).answered)
        }
        if self.unanswered.count != (UIApplication.sharedApplication().delegate as! AppDelegate).unanswered.count{
            self.unanswered.removeAll()
            self.unanswered.appendContentsOf((UIApplication.sharedApplication().delegate as! AppDelegate).unanswered)
        }
        if unansweredflag{
            if unanswered.count > 0{
                let firstViewController = [VC_Q(curr_una)]
                self.setViewControllers(firstViewController, direction: .Forward, animated: true, completion: nil)
            
            
            //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: unanswered.count)
                scrollToViewControllerp(firstViewController[0])
            }
        }else{
            if answered.count > 0{
                let firstViewController = [VC_Q(curr_a)]
                self.setViewControllers(firstViewController, direction: .Forward, animated: true, completion: nil)
            
            //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: answered.count)
                 scrollToViewControllerp(firstViewController[0])
            }
        }
    }
    
        func scrollToNextViewController() {
                var nextViewController: VC_Question!
                if unansweredflag{
                    if curr_una+1 < unanswered.count{
                        nextViewController = VC_Q(curr_una+1)
                        curr_una++
                        scrollToViewControllerp(nextViewController!)
                    }
                }else{
                    if curr_a+1 < answered.count{
                        nextViewController = VC_Q(curr_a+1)
                        curr_a++
                        scrollToViewControllerp(nextViewController!)
                    }
                }
            

        }
    
    func scrollToPrevViewController() {
            var nextViewController: VC_Question!
            if unansweredflag{
                if unanswered.count > 0 && curr_una > 0{
                    nextViewController = VC_Q(curr_una-1)
                    curr_una--
                    scrollToViewControllerp(nextViewController!)
                }
            }else{
                if answered.count > 0 && curr_a > 0{
                    nextViewController = VC_Q(curr_a-1)
                    curr_a--
                    scrollToViewControllerp(nextViewController!)
                }
            }
    }

    
        func scrollToViewController(index newIndex: Int) {
            if unansweredflag{
                let currentIndex = curr_una
                let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
                let nextViewController = VC_Q(newIndex)
                scrollToViewControllerp(nextViewController, direction: direction)
                
            }else{
                let currentIndex = curr_a
                let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
                let nextViewController = VC_Q(newIndex)
                scrollToViewControllerp(nextViewController, direction: direction)
            }
        }
        
        func scrollToViewControllerp(viewController: UIViewController,
            direction: UIPageViewControllerNavigationDirection = .Forward) {
                setViewControllers([viewController],
                    direction: direction,
                    animated: true,
                    completion: { (finished) -> Void in
                        self.notifyTutorialDelegateOfNewIndex()
                })
        }
        
        func notifyTutorialDelegateOfNewIndex() {
            var index = -1
            if unansweredflag{
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
    
    

    
    private func VC_Q(index:Int) -> VC_Question {
        let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
        if unansweredflag{
            let unan = unanswered[index]
            let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[ unan ]
            ret.poll = poll!
        }else{
            let an = answered[index]
            let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[ an ]
            ret.poll = poll!
        }
        return ret
    }
}

// MARK: UIPageViewControllerDataSource

extension PVC_PollViews: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            if unansweredflag{//if showing unanswered polls
                let previousIndex = curr_una - 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
                let unan = unanswered[previousIndex]
                let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[unan]
                ret.poll = poll
                curr_una--
                return ret
            }else{//if showing answered polls
                let previousIndex = curr_a - 1
            
                guard previousIndex >= 0 else {
                    return nil
                }
            
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
                let an = answered[previousIndex]
                let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[an]
                ret.poll = poll
                curr_a--
                return ret
            }
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            if unansweredflag{//if showing unanswered polls
                let previousIndex = curr_una + 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
                let unan = unanswered[previousIndex]
                let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[unan]
                ret.poll = poll
                curr_una++
                return ret
            }else{//if showing answered polls
                let previousIndex = curr_a + 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard answered.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
                let an = answered[previousIndex]
                let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[an]
                ret.poll = poll
                curr_a++
                return ret
            }
    }
}

extension PVC_PollViews: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
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
    func pvc_PollViews(tutorialPageViewController: PVC_PollViews,
        didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func pvc_PollViews(tutorialPageViewController:PVC_PollViews,
        didUpdatePageIndex index: Int)
    
}