//
//  AboutAppViewModel.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import RxCocoa
import RxSwift

class AboutAppViewModel: BaseViewModel {
    lazy var detailsList: [AppDetails] = [.definition, .video, .aiBot, .feedback, .usage]
    
    override init() {
        super.init()
    }
}

// MARK: Account User Actions
extension AboutAppViewModel {
    enum AppDetails {
        case definition
        case video
        case aiBot
        case feedback
        case usage
        
        var info: (image: UIImage?, text: String) {
            switch self {
            case .definition:
                let description = "eFitness uses live video motion capture to provide you with feedback on your body posture while doing physical activities."
                return (UIImage(named: "personal-trainer"), description)
                
            case .video:
                let description = "Workout infront of your camera."
                return (UIImage(named: "video"), description)
                
            case .aiBot:
                let description = "Ebot helps tracks all you movements."
                return (UIImage(named: "surveillance"), description)
                
            case .feedback:
                let description = "Get live feedback as you work out"
                return (UIImage(named: "feedback"), description)
                
            case .usage:
                let description = "Train anywhere, anytime."
                return (UIImage(named: "user-flow"),  description)
            }
        }
    }
}
