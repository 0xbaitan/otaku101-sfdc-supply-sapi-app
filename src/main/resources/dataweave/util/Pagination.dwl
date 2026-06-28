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

fun decodeCursor(token: String | Null): CursorState | Null =
    deserializeToken(token)

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

fun buildSoql(
  baseQuery: String,
  afterCursor: String | Null,
  beforeCursor: String | Null,
  pageSize: Number
): String =
  if (beforeCursor != null)
    baseQuery ++ " WHERE UUID__c < '" ++ beforeCursor ++ "' ORDER BY UUID__c DESC LIMIT " ++ (pageSize + 1)
  else if (afterCursor != null)
    baseQuery ++ " WHERE UUID__c > '" ++ afterCursor ++ "' ORDER BY UUID__c ASC LIMIT " ++ (pageSize + 1)
  else
    baseQuery ++ " ORDER BY UUID__c ASC LIMIT " ++ (pageSize + 1)

fun paginate(
  records: Array<Any>,
  pageSize: Number,
  afterCursor: String | Null,
  beforeCursor: String | Null
): {| data: Array<Any>, after: String | Null, before: String | Null |} =
  do {
    var sorted = if (beforeCursor != null) records[-1 to 0] else records
    var hasMore = sizeOf(sorted) > pageSize
    var page = if (hasMore) sorted[0 to pageSize - 1] else sorted
    ---
    {
      data: page,
      after: if (hasMore) page[-1].UUID__c else null,
      before: if ((afterCursor != null or beforeCursor != null) and sizeOf(page) > 0)
                page[0].UUID__c
              else
                null
    }
  }
