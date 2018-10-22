echo "running windows vault buildpack detect step"

if ($env:OS -eq "Windows_NT") {
  exit 0
} else {
  exit 1
}
