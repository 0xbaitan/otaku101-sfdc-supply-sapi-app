%dw 2.0

var validPhoneNumber: String = "+447768029391"
var validPhoneNumbers: Array<String> = [ "+447768029391", "+447935232497", "+447940179119", "+447770208977", "+447966449077"]
var invalidPhoneNumber: String = "+447768O29391" // Added O instead of 0
var invalidPhoneNumbers: Array<String> = [ "+447768029391", "+447935232497", "+44794O179119", "+447770208977", "+447966449077"] // Added O instead of 0