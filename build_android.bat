@echo off
echo Triggering Cloud Build for ShelfLife Android...
cd /d "%~dp0"
gcloud builds submit --config ShelfLife_Android/cloudbuild.yaml ShelfLife_Android/
pause
