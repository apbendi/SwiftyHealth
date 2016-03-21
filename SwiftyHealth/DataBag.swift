import UIKit
import CloudMine

class DataBag: CMObject {
    dynamic var stringData: String? = nil

    override init() {
        super.init()
    }

    override init(objectId theObjectId: String) {
        super.init(objectId: theObjectId)
    }

    required init!(coder: NSCoder) {
        self.stringData = coder.decodeObjectForKey("stringData") as? String
        super.init(coder: coder)
    }

    override func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(stringData, forKey: "stringData")
    }
}
