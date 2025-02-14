resource "aws_lambda_layer_version" "obdc_layer" {
  filename   = "./layers/odbc-layer.zip"
  layer_name = "odbc-layer"
  compatible_runtimes = ["dotnet6"]
  compatible_architectures = ["x86_64"]
  description = "Layers referenced in CICD Pipeline Code"
}

resource "aws_lambda_layer_version" "obdc_layer_17" {
  filename   = "./layers/odbc-layer-17.zip"
  layer_name = "odbc-layer-17"
  compatible_runtimes = ["dotnet6"]
  compatible_architectures = ["x86_64"]
  description = "Layers referenced in CICD Pipeline Code"
}

resource "aws_lambda_layer_version" "python_requests" {
  filename   = "./layers/python-requests.zip"
  layer_name = "python-requests"
  compatible_runtimes = ["python3.9"]
  compatible_architectures = ["x86_64"]
  description = "Layers referenced in CICD Pipeline Code"
}
