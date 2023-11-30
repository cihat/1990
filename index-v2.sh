#!/usr/bin/env sh

_() {
  CURRENT_YEAR=$(date +"%Y")
  echo "GitHub Username: "
  read -r USERNAME
  echo "GitHub Access token: "
  read -r ACCESS_TOKEN

  [ -z "$USERNAME" ] && exit 1
  [ -z "$ACCESS_TOKEN" ] && exit 1

  for YEAR in $(seq 2000 2000); do
    [ ! -d "$YEAR" ] && mkdir "$YEAR"

    cd "${YEAR}" || exit
    git init
    echo "**${YEAR}** - Generated by https://github.com/cihat/1990" \
      >README.md

    # Döngü içinde günleri işlemek için bir iç içe döngü
    for MONTH in {1..12}; do
      for DAY in {1..31}; do
        DATE="2000-$(printf %02d $MONTH)-$(printf %02d $DAY) 18:00:00"
        GIT_AUTHOR_DATE="$DATE" \
          GIT_COMMITTER_DATE="$DATE" \
          echo "* $(date)" >> README.md
        git add README.md
        git commit -m "${YEAR}-${MONTH}-${DAY}"
      done
    done

    git remote add origin "https://${ACCESS_TOKEN}@github.com/${USERNAME}/1990.git"
    git branch -M main
    git push -u origin main -f
    cd ..
    rm -rf "${YEAR}"
  done

  echo
  echo "Cool, check your profile now: https://github.com/${USERNAME}"
} && _

unset -f _
