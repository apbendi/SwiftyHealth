import UIKit
import CloudMine

class DataBag: CMObject {
    dynamic var stringData: String?

    override init() {
        super.init()
    }

    override init!(objectId theObjectId: String!) {
        super.init(objectId: theObjectId)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.stringData = coder.decodeObjectForKey("stringData") as? String
    }

    override func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(stringData, forKey: "stringData")
    }
}
