AccountName="staticwebweek1"
RG="Week1RG"


echo "--------------------------------------------------------"
echo "|           Uploading to Azure Storage Account         |"
echo "--------------------------------------------------------"

Connection_String=$(az storage account show-connection-string --name $AccountName --resource-group $RG --query connectionString -o tsv)
az storage blob upload-batch \
  --destination "\$web" \
  --source "Week1" \
  --connection-string $Connection_String \
  --overwrite \
  --pattern "*"
