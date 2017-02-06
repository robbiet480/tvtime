/******************************************************************************
 *
 * NZBGetQueueItem
 *
 ******************************************************************************/

import SwiftyJSON

public final class NZBQueueItem {
    
    public enum Status: String {
        case queued = "QUEUED"
        case paused = "PAUSED"
        case downloading = "DOWNLOADING"
        case fetching = "FETCHING"
        case ppQueued = "PP_QUEUED"
        case loadingPars = "LOADING_PARS"
        case verifyingSources = "VERIFYING_SOURCES"
        case repairing = "REPAIRING"
        case varifyingRepaired = "VERIFYING_REPAIRED"
        case renaming = "RENAMING"
        case unpacking = "UNPACKING"
        case moving = "MOVING"
        case executingSCript = "EXECUTING_SCRIPT"
        case ppFinished = "PP_FINISHED"
        case unknown = "UNKNOWN"
    }
    
    fileprivate struct Keys {
        static let nzbid = "NZBID"
        static let nzbName = "NZBName"
        static let status = "Status"
        static let fileSize = "FileSizeMB"
        static let remainingSize = "RemainingSizeMB"
        static let postStageProgress = "PostStageProgress"
        static let health = "Health"
    }
    
    public let id: Int
    public let title: String
    public let status: Status
    public let fileSize: Int
    public let remainingSize: Int
    public let postStageProgress: Int
    public let health: Int
    
    init?(json: JSON?, isSearch: Bool = false) {
        
        guard let json = json else {
            return nil
        }
        
        guard let id = json[Keys.nzbid].int, let title = json[Keys.nzbName].string, let statusRawValue = json[Keys.status].string, let status = Status(rawValue: statusRawValue) else {
            return nil
        }
        
        guard let fileSize = json[Keys.fileSize].int, let remainingSize = json[Keys.remainingSize].int else {
            return nil
        }
        
        guard let postStageProgress = json[Keys.postStageProgress].int else {
            return nil
        }

        guard let health = json[Keys.health].int else {
            return nil
        }

        self.id = id
        self.title = title
        self.status = status
        self.fileSize = fileSize
        self.remainingSize = remainingSize
        self.postStageProgress = postStageProgress
        
        self.health = Int((Double(health) / 1000) * 100)
    }
}
