//
//  EvincedLauncher.swift
//  XCUITestObjCInteropUITests
//
//  Created by Mykhailo Lysenko on 10/18/23.
//

import Foundation
import EvincedXCUISDK

@objc
class EvincedLauncher: NSObject {
    
    private static let maxAllowedCriticalIssues = 3
    
    
    /**
      Sets up the environment for testing a specific class or component.
      
      This method is used to configure the necessary dependencies and environment settings required for conducting unit tests on a particular class or component. It typically prepares the test environment, initializes variables, and performs any other setup tasks to ensure the class/component is in the desired state for testing.

      - Note: This method should be called before running any test cases that involve the class or component being tested. It is often invoked as part of the test suite's setup process.

      - Parameter testCase: An instance of `XCTestCase` or a subclass thereof. This parameter is used to provide access to the testing framework and its capabilities within the method.

      - Throws: An error if any setup tasks encounter issues. It is essential to catch and handle any errors that may occur during setup.

      - SeeAlso: `tearDown(testCase:)`, `XCTestCase`

      - Important: Ensure this method is called appropriately within your testing suite to establish a consistent and predictable testing environment. Proper setup is essential for reliable and repeatable unit tests.
    */
    @objc
    static func setup(testCase: XCTestCase) throws {
        EvincedEngine.setupOfflineCredentials(serviceAccountId: "YOUR SERVICE ACCOUNT ID",
                                              accessToken: "YOUR ACCESS TOKEN")
        EvincedEngine.testCase = testCase
    }
    

    /**
      Generates a report and returns a set of attachments.

      This method is responsible for generating a report, which typically consists of various pieces of data or content that are organized into attachments. The attachments may contain information, files, or other data relevant to the report's purpose. This method may be used in scenarios where you need to collect and return structured data as a report, which can be further processed, displayed, or sent to external systems.

      - Note: When calling this method, be prepared to handle any potential errors it may throw. Errors could occur during the report generation process, such as data retrieval problems, file I/O errors, or other unexpected issues.

      - Returns: A set of attachments containing the report data. The attachments may be in various formats, such as files, objects, or other data structures.

      - Throws: An error if the report generation process encounters any issues. Proper error handling is essential to gracefully manage any unexpected problems.

      - SeeAlso: `attachments`, `report generation`, `try-catch`, `@objc`

      - Important: Ensure that this method is used in a way that aligns with the specific requirements of your application. Customize the report generation process to match the desired content and format of the report.

      - Warning: Be cautious when using this method in production code, as it may have performance implications. It should be used judiciously and only when necessary for generating and handling reports.
    */
    @objc
    static func report() throws {
        let report = try EvincedEngine.report()
        
        XCTAssertFalse(report.isOk, "Report should not be OK.")
    }
    
    /**
      Verifies the number of `.critical` issues in the report to ensure it is within acceptable limits.

      This method is responsible for checking the report to ensure that the quantity of `.critical` issues, which are typically indicators of severe problems, does not exceed the predefined limit specified by the `maxAllowedCriticalIssues` variable. The goal is to maintain the quality and reliability of the report by keeping the number of critical issues in check.

      - Note: When calling this method, be prepared to handle any potential errors it may throw. Errors could occur during the verification process, such as issues related to data retrieval, report validation, or other unexpected problems.

      - Throws: An error if the verification process encounters any issues or if the number of critical issues exceeds the allowed limit. Proper error handling is essential to manage any unexpected problems.

      - SeeAlso: `verification`, `.critical` issues, `maxAllowedCriticalIssues`, `try-catch`, `@objc`

      - Parameters: None, but this method relies on the `maxAllowedCriticalIssues` variable, which should be appropriately configured based on the application's requirements.

      - Important: Ensure that this method is used in the context of report validation and quality control. The `maxAllowedCriticalIssues` variable should be carefully set to match your application's specific criteria.

      - Warning: Be cautious when using this method in production code, as it may have performance implications. It should be used judiciously and only when necessary for verifying the report's quality.
    */
    @objc
    static func reportStored() throws {
        let reports = try EvincedEngine.reportStored()
        
        reports.forEach { report in
            let totalIssuesCount = report.issuesCount(severity: .critical)
            
            XCTAssertTrue(totalIssuesCount < maxAllowedCriticalIssues)
        }
    }
    
    /// Watch for screen state changes and record all accessibility issues until ``stopAnalyze()`` is called.
    /// It works the same way as ``analyze(_:config:)`` but collects snapshot on each XCUI command that can change application state.
    /// - Parameter config: The config for setting report parameters.
    @objc
    static func startAnalyze() {
        EvincedEngine.startAnalyze()
    }
    
    /// An object that defines the options that will be used when performing accessibility validations and generating reports
    @objc
    static func stopAnalyze() {
        EvincedEngine.stopAnalyze()
    }
    
    /// Stores the accessibility data of an application for further validation. When no application is set, currently active app is analyzed.
    /// - Parameters:
    ///   - application: Tested application. If `nil` currently launched application would be tested. Default is `nil`.
    ///   - config: The config for setting report parameters.
    /// - Throws: `EvincedError` instance.
    @objc
    static func analyze(_ app: XCUIApplication) throws {
        // Or you can use ``try app.evAnalyze()``
        try EvincedEngine.analyze(app)
    }
    
    /**
      Verifies color contrast to ensure accessibility and usability.

      This method serves as an example for testing the color contrast of elements within the user interface. Ensuring adequate color contrast is essential for accessibility and usability, as it impacts the readability and usability of your application for individuals with varying visual abilities.

      - Note: When calling this method, be prepared to handle any potential errors it may throw. Errors might occur during the verification process or due to issues with color contrast calculations or data retrieval.

      - Throws: An error if the color contrast verification process encounters any issues or if the contrast does not meet accessibility guidelines. Proper error handling is essential to address any unexpected problems.

      - SeeAlso: Accessibility, usability, color contrast, try-catch, @objc

      - Parameters: None, as this method primarily serves as an example. In a real-world scenario, you would typically provide UI elements to be tested for color contrast.

      - Important: Ensure that color contrast is a fundamental consideration during the design and development of your application. Regularly verifying color contrast helps create a more inclusive and user-friendly product.

      - Warning: Be cautious when using this method in production code, as it may have performance implications. It should be used judiciously and integrated into your testing and development processes for accessibility compliance.
    */
    @objc
    static func verifyColorContrast() throws {
        EvincedEngine.options.config = EvincedConfig(includeFilters: IssueFilter(issueTypes: .colorContrast))
        
        let contrastReport = try EvincedEngine.report()
        XCTAssertEqual(contrastReport.elements.count, 1, "1 color contrast issue must be found in the report")
    }
}

private extension Report {
    
    /**
      Counts the number of accessibility issues based on their severity.

      This method is responsible for calculating and returning the count of accessibility issues within your iOS application. The count is determined based on the specified `severity` level, helping you identify and address accessibility concerns according to their importance or impact.

      - Parameter severity: The severity level of accessibility issues to count. Common values include `.critical`, `.major`, `.minor`, and `.cosmetic`. This parameter allows you to focus on specific issue categories.

      - Returns: The number of accessibility issues matching the provided `severity` level. This count represents the issues that need attention based on their severity.

      - SeeAlso: Accessibility, issues, severity levels, @objc

      - Important: Regularly using this method to track accessibility issues can help maintain a more inclusive and user-friendly application. It is crucial to take appropriate actions to resolve identified issues and improve accessibility.

      - Note: Ensure that the `severity` parameter is set to the appropriate level to match your current focus, as different severity levels may require varying levels of attention and resources.
    
     - Warning: While counting issues is an essential part of accessibility efforts, it is equally crucial to take corrective actions to resolve them and enhance the overall user experience.
     **/
    func issuesCount(severity: SeverityType) -> Int {
        elements.reduce (0) { sum, element in
            sum + element.issues
                .filter { $0.severity.type == severity }
                .count
        }
    }
}
