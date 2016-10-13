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
        emptyVC = self.storyboard?.instantiateViewControllerWithIdentifier("emptyVC") as! VC_Text

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dataSource = self
        delegate = self

        if self.answered.count != (UIApplication.sharedApplication().delegate as! AppDelegate).answered.count{
            self.answered.removeAll()
            self.answered.appendContentsOf((UIApplication.sharedApplication().delegate as! AppDelegate).answered)
        }
        if self.unanswered.count != (UIApplication.sharedApplication().delegate as! AppDelegate).unanswered.count{
            self.unanswered.removeAll()
            self.unanswered.appendContentsOf((UIApplication.sharedApplication().delegate as! AppDelegate).unanswered)
        }
        if unansweredflag == 0{
            if (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count > 0{
                let firstViewController = [VC_Q(curr_all)]
                self.setViewControllers(firstViewController, direction: .Forward, animated: true, completion: nil)
                //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count)
                scrollToViewControllerp(firstViewController[0], direction: .Forward)
            }
        }else if unansweredflag == 1{
            if unanswered.count > 0{
                let firstViewController = [VC_Q(curr_una)]
                self.setViewControllers(firstViewController, direction: .Forward, animated: true, completion: nil)
            
            
            //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: unanswered.count)
                scrollToViewControllerp(firstViewController[0], direction: .Forward)
            }
        }else{
            if answered.count > 0{
                let firstViewController = [VC_Q(curr_a)]
                self.setViewControllers(firstViewController, direction: .Forward, animated: true, completion: nil)
            
            //set delegate for poll counts and updating
                pvc_delegate?.pvc_PollViews(self, didUpdatePageCount: answered.count)
                 scrollToViewControllerp(firstViewController[0], direction: .Forward)
            }
        }
    }
    
        func scrollToNextViewController() {
                var nextViewController: VC_Question!
            if unansweredflag == 0{
                if curr_all+1 < (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count{
                    nextViewController = VC_Q(curr_all+1)
                    curr_all++
                    scrollToViewControllerp(nextViewController!,direction: .Forward)
                }
            }else if unansweredflag == 1{
                if curr_una+1 < unanswered.count{
                    nextViewController = VC_Q(curr_una+1)
                    curr_una++
                    scrollToViewControllerp(nextViewController!,direction: .Forward)
                }
            }else{
                if curr_a+1 < answered.count{
                    nextViewController = VC_Q(curr_a+1)
                    curr_a++
                    scrollToViewControllerp(nextViewController!,direction: .Forward )
                }
            }
            

        }
    
    func scrollToPrevViewController() {
            var nextViewController: VC_Question!
        if unansweredflag == 0{
            if (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count > 0 && curr_all > 0{
                nextViewController = VC_Q(curr_all-1)
                curr_all--
                scrollToViewControllerp(nextViewController!,direction: .Reverse)
            }
        }else if unansweredflag == 1{
                if unanswered.count > 0 && curr_una > 0{
                    nextViewController = VC_Q(curr_una-1)
                    curr_una--
                    scrollToViewControllerp(nextViewController!, direction: .Reverse)
                }
            }else{
                if answered.count > 0 && curr_a > 0{
                    nextViewController = VC_Q(curr_a-1)
                    curr_a--
                    scrollToViewControllerp(nextViewController!,direction: .Reverse)
                }
            }
    }

    
        func scrollToViewController(index newIndex: Int) {
            if unansweredflag == 0{
                let currentIndex = curr_all
                let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
                let nextViewController = VC_Q(newIndex)
                scrollToViewControllerp(nextViewController, direction: direction)
            }else if unansweredflag == 1{
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
                if (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count > 0{
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
    
    func togglePVC(flag: Int){
        if unansweredflag == 0{
            if (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count > 0{
                scrollToViewControllerp(VC_Q(curr_all), direction: .Forward)
            }else{
                emptyVC.msg = "No more questions :("
                scrollToViewControllerp(emptyVC, direction: .Forward)
            }
        }else if unansweredflag == 1{
            if unanswered.count > 0{
                scrollToViewControllerp(VC_Q(curr_una), direction: .Forward)
            }else{
                emptyVC.msg = "No more unanswered questions :("
                scrollToViewControllerp(emptyVC, direction: .Forward)
            }
        }else{
            if answered.count > 0{
                scrollToViewControllerp(VC_Q(curr_a), direction: .Forward)
            }else{
                emptyVC.msg = "No more answered questions :("
                scrollToViewControllerp(emptyVC, direction: .Forward)
            }
        }
    
    }
    
    private func VC_Q(index:Int) -> VC_Question {
        let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
        if unansweredflag == 0{
            print("Current filter: All - Creating poll for index " + String(index))
            let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[index]
            if poll?.resp == -1{
                for(var i = 0; i < unanswered.count; i++){
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
            let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[ unan ]
            poll?.index = unan
            poll?.isUna = true
            ret.unans_index = index
            ret.poll = poll!
        }else{
            let an = answered[index]
            let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[ an ]
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
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            if unansweredflag == 0{
                let previousIndex = curr_all - 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
                let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[previousIndex]
                ret.poll = poll
                curr_all--
                return ret
            }else if unansweredflag == 1{//if showing unanswered polls
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
            if unansweredflag == 0{
                let previousIndex = curr_all + 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard (UIApplication.sharedApplication().delegate as! AppDelegate).Q.count > previousIndex else {
                    return nil
                }
                
                let ret = (self.storyboard?.instantiateViewControllerWithIdentifier("a_poll"))! as! VC_Question
                let poll = (UIApplication.sharedApplication().delegate as! AppDelegate).Q[previousIndex]
                ret.poll = poll
                curr_all++
                return ret
            }else if unansweredflag == 1{//if showing unanswered polls
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