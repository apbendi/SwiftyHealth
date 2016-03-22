import Foundation
import CMHealth

struct Tasks {
    static var consent: ORKOrderedTask {
        return ConsentBuilder.consentTask()
    }

    static var survey: ORKOrderedTask {
        return SurveyBuilder.task
    }
}

private struct ConsentBuilder {
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

private struct SurveyBuilder {
    static var task: ORKOrderedTask {
        let task = ORKOrderedTask(identifier: "SwiftyHealthSurveyTask", steps: steps)

        return task
    }

    static var steps: [ORKStep] {
        return [dobQuestion, awesomeQuestion, typeQuestion, selectQuestion]
    }

    static var dobQuestion: ORKQuestionStep {
        return ORKQuestionStep(identifier: "SwiftyHealthBirthQuestion", title: "When were you born?", answer: ORKAnswerFormat.dateAnswerFormat())
    }

    static var awesomeQuestion: ORKQuestionStep {
        return ORKQuestionStep(identifier: "SwiftyHealthAwesomeQuestion", title: "How awesome is this survey?", text: "Scale of 1-10", answer: ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 1, defaultValue: 10, step: 1))
    }

    static var typeQuestion: ORKQuestionStep {
        return ORKQuestionStep(identifier: "SwiftyHealthTypeQuestion", title: "Type some random text!", text: nil, answer: ORKTextAnswerFormat(maximumLength: 1024))
    }

    static var selectQuestion: ORKQuestionStep {
        return ORKQuestionStep(identifier: "SwiftyHealthSelectQuestion", title: "Which best describes this survey?", answer: ORKTextChoiceAnswerFormat(style: .SingleChoice, textChoices: [ORKTextChoice(text: "Amazing", value: "Amazing"), ORKTextChoice(text:"Unbelievable", value:"Unbelievable"),  ORKTextChoice(text:"Incredible", value:"Incredible"),  ORKTextChoice(text:"Awe Inspiring", value:"Awe Inspiring")]))
    }
}
