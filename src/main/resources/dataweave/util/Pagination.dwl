%dw 2.0
import * from dw::core::Binaries
import * from dw::Runtime

type CursorState = {
    targetDate: String,
    targetId: String,
    direction: String,
    limit: Number,
    filters: Object
}

type QueryParams = {|
	before?: String,
	after?: String,
	limit?: Number,
	q?: String,
	filters?: Object,
	sort?: Object
|}

fun deserializeToken(token: String | Null): CursorState | Null = 
    if (isEmpty(token)) null 
    else try(() -> read(fromBase64(token), "application/json") as CursorState) orElse null

fun resolvePaginationFlags(hasExtraRecord: Boolean, direction: String, hasIncomingToken: Boolean) = do {
    var wasMovingBackward = direction == "backward"
    var wasMovingForward = direction == "forward"
    ---
    {
        hasNext: if (wasMovingForward) hasExtraRecord else true,
        hasPrevious: if (wasMovingBackward) hasExtraRecord else (wasMovingForward and hasIncomingToken)
    }
}

fun serializeToken(record: Object | Null, direction: String, limit: Number, filters: Object): String | Null = 
    if (isEmpty(record)) null 
    else toBase64(write({
        targetId: record.UUID__c as String,
        direction: direction,
        limit: limit,
        filters: filters
    }, "application/json"))