
type Supplier = {
	name: String,
	phone?: String,
	email?: String,
	website?: String,
	status?: "ACTIVE" | "INACTIVE" | "ONBOARDING"
}

type SupplierCreateRequest = {
	
}

type UpdateSupplier = {
	name?: String,
	phone?: String,
	email?: String,
	website?: String,
	status?: "ACTIVE" | "INACTIVE" | "ONBOARDING" 
}


fun isSupplier(o: Any) =
	o



