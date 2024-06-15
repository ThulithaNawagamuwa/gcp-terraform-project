# outputs the CDN Backend bucket id
output "backend_bucket_id" {
  value = google_compute_backend_bucket.static-webpage-backend.id
}