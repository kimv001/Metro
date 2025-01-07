# Define the default path for the solution
$defaultPath = "c:/Users/BHR_VERME522/metro_github_sources/metro"

# Change to the project directory
Set-Location -Path $defaultPath

# Run sqlfluff fix on all .sql files in the directory and subdirectories
sqlfluff fix  "c:/Users/BHR_VERME522/metro_github_sources/metro/adf/**/*.sql" --dialect tsql --rules L010,L016 --exclude-rules L014
