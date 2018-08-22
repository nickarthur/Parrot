
import XCTest

class VariableGeneratorTests: XCTestCase {
    let expectedVariableName = "varName"
    let expectedVariableType = "String"
    let expectedReturnValue = "CustomReturnValue"
    
    // MARK: - mockImplementationLines
    func testMockImplementationLines_WhenIsWeak_ThenResultContainsWeakModifier() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: nil, isGetSet: false, isWeak: true)
        guard let result = testVariable.mockImplementationLines.element(at: 0) else { XCTFail(); return }
        
        XCTAssertTrue(result.hasPrefix("weak"))
    }
    
    func testMockImplementationLines_WhenIsNotWeak_ThenResultDoesNotContainWeakModifier() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: nil, isGetSet: false, isWeak: false)
        guard let result = testVariable.mockImplementationLines.element(at: 0) else { XCTFail(); return }
        
        XCTAssertFalse(result.hasPrefix("weak"))
    }
    
    func testMockImplementationLines_WhenIsGetSet_AndWhenIsWeak_ThenResultContainsWeakModifier() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: nil, isGetSet: true, isWeak: true)
        guard let result = testVariable.mockImplementationLines.element(at: 0) else { XCTFail(); return }
        
        XCTAssertTrue(result.hasPrefix("weak"))
    }
    
    func testMockImplementationLines_WhenIsGetSet_AndWhenIsNotWeak_ThenResultDoesNotContainWeakModifier() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: nil, isGetSet: true, isWeak: false)
        guard let result = testVariable.mockImplementationLines.element(at: 0) else { XCTFail(); return }
        
        XCTAssertFalse(result.hasPrefix("weak"))
    }
    
    func testMockImplementationLines_WhenIsGetSet_AndHasDefaultReturnValue_ThenResultContainsDefaultReturnValue() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: expectedReturnValue, isGetSet: true, isWeak: false)
        guard let result = testVariable.mockImplementationLines.element(at: 0) else { XCTFail(); return }
        
        XCTAssertTrue(result.hasSuffix(expectedReturnValue))
    }
    
    func testMockImplementationLines_WhenIsGetSet_AndDoesNotHaveDefaultReturnValue_ThenResultDoesNotContainDefaultReturnValue() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: nil, isGetSet: true, isWeak: false)
        guard let result = testVariable.mockImplementationLines.element(at: 0) else { XCTFail(); return }
        
        XCTAssertEqual(result, "var \(expectedVariableName): \(expectedVariableType) = <#Default return value#>")
    }
    
    func testMockImplementationLines_WhenIsNotGetSet_ThenResultIsComputedVariable() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: nil, isGetSet: false, isWeak: false)
        
        let result = testVariable.mockImplementationLines
        
        XCTAssertEqual(result, ["var \(expectedVariableName): \(expectedVariableType) {",
            "stub.\(expectedVariableName)CallCount += 1",
            "return stub.\(expectedVariableName)ShouldReturn",
            "}"])
    }
    
    // MARK: - stubEntries
    func testStubEntries_WhenHasDefaultReturnValue_ThenResultContainsDefaultReturnValue() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: expectedReturnValue, isGetSet: false, isWeak: false)
        
        let result = testVariable.stubEntries
        
        XCTAssertEqual(result, ["var \(expectedVariableName)CallCount = 0",
            "var \(expectedVariableName)ShouldReturn: \(expectedVariableType) = \(expectedReturnValue)"])
    }
    
    func testStubEntries_WhenDoesNotHaveDefaultReturnValue_ThenResultDoesNotContainDefaultReturnValue() {
        let testVariable = Variable(name: expectedVariableName, type: expectedVariableType, defaultReturnValue: nil, isGetSet: false, isWeak: false)
        
        let result = testVariable.stubEntries
        
        XCTAssertEqual(result, ["var \(expectedVariableName)CallCount = 0",
            "var \(expectedVariableName)ShouldReturn: \(expectedVariableType) = <#Default return value#>"])
    }
}