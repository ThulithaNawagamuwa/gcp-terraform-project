# Cloud Storage Bucket to store website (Once a bucket has been created, its location can't be changed.)
resource "google_storage_bucket" "static_webpage" {
  name     = "static-webpage-bucket"
  location = "US"                          # Multi-region location code
  storage_class = "STANDARD"
}


# Make new objects public
resource "google_storage_object_access_control" "public_rule" {
  object = google_storage_bucket_object.static_site_src.output_name
  bucket = google_storage_bucket.static_webpage.id
  role   = "READER"
  entity = "allUsers"
}

# Upload the html file to the bucket
resource "google_storage_bucket_object" "static_site_src" {
  name   = "index.html"
  source = "${path.module}/index.html"
  bucket = google_storage_bucket.static_webpage.name
  
}


# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "static-webpage-backend" {
  name        = "static-website-backend-bucket"
  description = "Contains files needed by the website"
  bucket_name = google_storage_bucket.static_webpage.name
  enable_cdn  = true
}

