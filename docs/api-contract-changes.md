# API Contract & Salesforce sObject Changes

## RAML Spec Project Changes Needed

These changes need to be made in the API spec project published to Exchange (group: `365d8e9a-5b53-4d65-8776-8d29047c4ac6`, artifact: `otaku101-sfdc-supply-sapi`).

### 1. `supplier.json` schema — fix `supplierId` type and status enum

```diff
- "supplierId": {
-   "description": "Unique identifier for the supplier",
-   "type": "integer",
-   "minimum": 1
- }
+ "supplierId": {
+   "description": "Unique identifier for the supplier",
+   "type": "string",
+   "format": "uuid"
+ }

- "status": {
-   "description": "Current operational status of the supplier within the system",
-   "type": "string",
-   "enum": ["Active", "Pending", "Inactive"]
- }
+ "status": {
-   "description": "Current operational status of the supplier within the system",
-   "type": "string",
-   "enum": ["Active", "Onboarding", "Inactive"]
- }
```

### 2. `supplier-pagination-metadata.json` — outdated

The `lastId` field is **not used** by the actual implementation. The API uses cursor-based pagination with `before`/`after` query parameters and base64-encoded cursor tokens. This schema can either be removed or updated to reflect the actual cursor state structure (`CursorState` in `Pagination.dwl`).

### 3. Missing JSON schemas

The following resource types need JSON schemas defined in the RAML spec:

- **Contact**: id (uuid), name, email, phone, title
- **Facility**: id (uuid), name, type, status
- **ProductCategory**: id (uuid), name, description
- **Product**: id (uuid), name, sku, price, description, categoryId
- Also needed: request bodies for create/update variants of each (all fields optional except name on create)

### 4. DataWeave vs RAML status value mismatch

The DataWeave code (`Types.dwl`) uses uppercase status values:
```
status?: "ACTIVE" | "INACTIVE" | "ONBOARDING"
```

The RAML schema (`supplier.json`) uses capitalized:
```
enum: ["Active", "Pending", "Inactive"]
```

The implementation maps directly from API request body to Salesforce (which stores uppercase). **Recommendation**: align the RAML spec to use `Active`, `Onboarding`, `Inactive` and add a DataWeave map to normalize to uppercase before storing in Salesforce.

---

## Salesforce sObject Setup

### A. Contact — extend **standard Contact** with 2 custom fields

| Field | Type | Description |
|-------|------|-------------|
| `UUID__c` | Text(36), External ID, Unique | API identifier |
| `Supplier__c` | Lookup(Supplier__c) | Parent supplier |

Standard fields used by the API: `LastName` (maps to `name`), `Email`, `Phone`, `Title`

### B. Facility__c — new custom object

| Field | Type | Description |
|-------|------|-------------|
| `UUID__c` | Text(36), External ID, Unique | API identifier |
| `Supplier__c` | Lookup(Supplier__c) | Parent supplier |
| `Name` | Text(255) | Facility name |
| `Type__c` | Picklist | Warehouse, Manufacturing, Distribution, Office |
| `Status__c` | Picklist | Active, Inactive, Under Maintenance |

### C. ProductCategory__c — new custom object

| Field | Type | Description |
|-------|------|-------------|
| `UUID__c` | Text(36), External ID, Unique | API identifier |
| `Name` | Text(255) | Category name |
| `Description__c` | Long Text Area(32768) | Description |

### D. Product__c — new custom object

| Field | Type | Description |
|-------|------|-------------|
| `UUID__c` | Text(36), External ID, Unique | API identifier |
| `Supplier__c` | Lookup(Supplier__c) | Parent supplier |
| `ProductCategory__c` | Lookup(ProductCategory__c) | Category |
| `Name` | Text(255) | Product name |
| `SKU__c` | Text(100) | Stock keeping unit |
| `Price__c` | Currency(16,2) | Unit price |
| `Description__c` | Long Text Area(32768) | Product description |

### E. Inventory__c — new custom object (not yet implemented)

| Field | Type | Description |
|-------|------|-------------|
| `UUID__c` | Text(36), External ID, Unique | API identifier |
| `Facility__c` | Lookup(Facility__c) | Parent facility |
| `Product__c` | Lookup(Product__c) | Product |
| `Quantity__c` | Number(18,0) | Stock quantity |
