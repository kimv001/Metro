# Define the default path for the solution
$defaultPath = "c:/Users/BHR_VERME522/metro_github_sources/metro"

# Change to the project directory
Set-Location -Path $defaultPath

# Add the directory where sqlfluff is installed to the PATH
$env:Path += ";C:\Users\BHR_VERME522\AppData\Roaming\Python\Python313\Scripts"

# Verify sqlfluff installation
sqlfluff --version

# Run sqlfluff fix on all .sql files in the directory and subdirectories
sqlfluff lint "./**/*.sql" --dialect tsql --rules L010,L016 --exclude-rules L014 --ignore parsing