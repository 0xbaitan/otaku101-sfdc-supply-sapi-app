%dw 2.0

type Supplier = {
    name: String,
    phone?: String,
    email?: String,
    website?: String,
    status?: "ACTIVE" | "INACTIVE" | "ONBOARDING"
}

type SupplierCreateRequest = {
    name: String,
    phone?: String,
    email?: String,
    website?: String,
    status?: "ACTIVE" | "INACTIVE" | "ONBOARDING"
}

type UpdateSupplier = {
    name?: String,
    phone?: String,
    email?: String,
    website?: String,
    status?: "ACTIVE" | "INACTIVE" | "ONBOARDING"
}

type Contact = {
    name: String,
    email?: String,
    phone?: String,
    title?: String
}

type CreateContactRequest = {
    name: String,
    email?: String,
    phone?: String,
    title?: String
}

type UpdateContact = {
    name?: String,
    email?: String,
    phone?: String,
    title?: String
}

type Facility = {
    name: String,
    type?: "Warehouse" | "Manufacturing" | "Distribution" | "Office",
    status?: "Active" | "Inactive" | "Under Maintenance"
}

type CreateFacilityRequest = {
    name: String,
    type?: "Warehouse" | "Manufacturing" | "Distribution" | "Office",
    status?: "Active" | "Inactive" | "Under Maintenance"
}

type UpdateFacility = {
    name?: String,
    type?: "Warehouse" | "Manufacturing" | "Distribution" | "Office",
    status?: "Active" | "Inactive" | "Under Maintenance"
}

type ProductCategory = {
    name: String,
    description?: String
}

type CreateProductCategoryRequest = {
    name: String,
    description?: String
}

type UpdateProductCategory = {
    name?: String,
    description?: String
}

type Product = {
    name: String,
    sku?: String,
    price?: Number,
    description?: String,
    categoryId?: String
}

type CreateProductRequest = {
    name: String,
    sku?: String,
    price?: Number,
    description?: String,
    categoryId?: String
}

type UpdateProduct = {
    name?: String,
    sku?: String,
    price?: Number,
    description?: String,
    categoryId?: String
}
