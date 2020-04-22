//
//  OnBoardingPageViewController.swift
//  uselessApp
//
//  Created by Tamara Erlij on 22/04/20.
//  Copyright © 2020 Tamara Erlij. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {

        override func viewDidLoad() {
            super.viewDidLoad()

            dataSource = self
            
            if let firstViewController = orderedViewControllers.first {
                setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        
        private(set) lazy var orderedViewControllers: [UIViewController] = {
            return [newOnboardingViewController(identifier: K.onboardingViewController1),
                    newOnboardingViewController(identifier: K.onboardingViewController2),
                    newOnboardingViewController(identifier: K.onboardingViewController3)]
        }()
        
        private func newOnboardingViewController(identifier: String) -> UIViewController {
            let onboardingVC = storyboard?.instantiateViewController(withIdentifier: identifier)
            return onboardingVC!
        }
        
        func presentationCount(for pageViewController: UIPageViewController) -> Int {
            return orderedViewControllers.count
        }
        
        func presentationIndex(for pageViewController: UIPageViewController) -> Int {
            guard let firstViewController = viewControllers?.first,
                let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                    return 0
            }
            
            return firstViewControllerIndex
        }
    }

    extension OnboardingPageViewController: UIPageViewControllerDataSource {
        
        func pageViewController(_ pageViewController: UIPageViewController,
                                viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
        }
    }
