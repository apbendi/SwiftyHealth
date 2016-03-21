import Foundation
import CMHealth

struct ConsentBuilder {
    static func consentTask() -> ORKOrderedTask {
        let task = ORKOrderedTask(identifier: "SwiftyConsentTask", steps: self.steps())

        return task
    }

    private static func steps() -> [ORKStep] {
        let doc = self.consentDoc()
        doc.title = NSLocalizedString("Swifty Health Consent", comment: "")
        doc.signaturePageTitle = NSLocalizedString("Swifty Consent", comment: "")


        return [self.visualStep(doc), self.sharingStep(), self.reviewStep(doc)]
    }

    private static func visualStep(doc: ORKConsentDocument) -> ORKVisualConsentStep {
        let step = ORKVisualConsentStep(identifier: "SwiftyConsentVisualStep", document: doc)
        return step
    }

    private static func sharingStep() -> ORKConsentSharingStep {
        let step = ORKConsentSharingStep(identifier: "SwiftyConsentSharingStep", investigatorShortDescription: "Swifty Healthcare Co.", investigatorLongDescription: "Swifty Healthcare Co.", localizedLearnMoreHTMLContent: "<html><body><b>Swifty Healcare Co.</b></body></html>")

        return step
    }

    private static func reviewStep(doc: ORKConsentDocument) -> ORKConsentReviewStep {
        let step = ORKConsentReviewStep(identifier: "SwiftyConsentReviewStep", signature: doc.signatures?.first, inDocument: doc)

        step.title = NSLocalizedString("Review Swifty Consent", comment: "")
        step.text = NSLocalizedString("This is the text for Swifty Consent, lorem ipsum dolor latin words are here", comment: "")

        return step
    }

    private static func consentDoc() -> ORKConsentDocument {
        let document = ORKConsentDocument()
        document.addSignature(self.signature())
        document.sections = self.sections()

        return document
    }

    private static func signature() -> ORKConsentSignature {
        return ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "SwiftyConsentSignature")
    }

    private static func sections() -> [ORKConsentSection] {
        return [self.welcomeSection(), self.timeSection(), ORKConsentSection.cmh_sectionForSecureCloudMineDataStorage()]
    }

    private static func welcomeSection() -> ORKConsentSection {
        let section = ORKConsentSection(type: .Overview)
        section.summary = "Welcome to the SwiftyHealth demo and testbed. ResearchKit with CMHealth in Swift!"
        section.title = "SwiftyHealth"

        return section
    }

    private static func timeSection() -> ORKConsentSection {
        let section = ORKConsentSection(type: .TimeCommitment)
        section.summary = "It won't take any time"

        return section
    }
}
