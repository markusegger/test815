echo Ready to push to branch %1
git add . 
git diff --quiet --exit-code --cached || git commit -m "Rest document updated by CI" && git push -u origin %1 && echo "Document updated"
