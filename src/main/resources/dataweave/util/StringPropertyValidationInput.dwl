%dw 2.0
import every from dw::core::Arrays
type StringPropertyValueValidation = {
	v: String,
    k?: String
}
type StringPropertyValidationInput = String | StringPropertyValueValidation | Array<StringPropertyValueValidation | String>
fun isStringPropertyValidationInput(e: Any): Boolean =
    e match {
	case is String -> true
        case obj is Object -> 
            (obj.v is String) and (obj.k == null or obj.k is String)
        case arr is Array -> 
            arr every isStringPropertyValidationInput($)
        else -> false
}
