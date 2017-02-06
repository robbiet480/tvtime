/******************************************************************************
 *
 * UIAlertController+Extensions.swift
 *
 ******************************************************************************/
import TVTimeSDK

extension UIAlertController {
    
    typealias ActionBlock = (UIAlertAction) -> ()
    
    static func errorAlertAction(_ title: String?, message: String!) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        return alertController
    }
    
    static func alertWithTitle(_ title: String?, message: String?, buttonTitles: [String]?, cancelTitle: String? = nil, cancelActionBlock: ActionBlock? = nil, actionBlock: ActionBlock?) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let buttonTitles = buttonTitles {
            
            buttonTitles.forEach({
                let alertAction = UIAlertAction(title: $0, style: .default, handler: { (action) in
                    
                    if let actionBlock = actionBlock {
                        actionBlock(action)
                    }
                })
                
                alertController.addAction(alertAction)
            })
        }
        
        if let cancelTitle = cancelTitle {
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelActionBlock)
            
            alertController.addAction(cancelAction)
        }
        
        if buttonTitles == nil && cancelTitle == nil {
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { (action) in
                
                if let actionBlock = actionBlock {
                    actionBlock(action)
                }
            })
            
            alertController.addAction(okAction)
        }
        
        
        return alertController
        
    }
    
    static func qualityActionSheet<T>(_ title: String, selectedProfileId: String? = nil, qualityProfiles: [T], completion: ((T) -> Void)? = nil) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for qualityProfile in qualityProfiles {
            var title = ""
            
            if let q = qualityProfile as? SeriesQualityProfile {
                
                if let selectedProfileId = selectedProfileId {
                    if String(q.id) == selectedProfileId {
                        title = "✓ "
                    }
                }
                
                title += q.name
            } else if let q = qualityProfile as? MovieProfile {
                
                if let selectedProfileId = selectedProfileId {
                    if q.id == selectedProfileId {
                        title = "✓ "
                    }
                }
                
                title += q.title
            }
            
            let qualityAction = UIAlertAction(title: title, style: .default) { (action) in
                
                if let completion = completion {
                    completion(qualityProfile)
                }
            }
            
            alertController.addAction(qualityAction)
            
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
        
    }
    
    static func seasonsActionSheet(_ completion: ((Media.MonitorType) -> Void)?) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Monitor", message: nil, preferredStyle: .actionSheet)
        
        for type in Media.MonitorType.allValues {
            
            let qualityAction = UIAlertAction(title: type.rawValue, style: .default) { (action) in
                
                if let completion = completion {
                    completion(type)
                }
            }
            
            alertController.addAction(qualityAction)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
        
    }
    
    static func changeItemActionSheet(qualityCompletion: ((Void) -> Void)?, deleteCompletion: ((Void) -> Void)?) -> UIAlertController {
        
        let alertController = UIAlertController(title: "Change", message: nil, preferredStyle: .actionSheet)
        let qualityAction = UIAlertAction(title: "Quality", style: .default) { (action) in
            
            if let qualityCompletion = qualityCompletion {
                qualityCompletion()
            }
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            if let deleteCompletion = deleteCompletion {
                deleteCompletion()
            }
        }
        
        alertController.addAction(qualityAction)
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        
        return alertController
        
    }

}
