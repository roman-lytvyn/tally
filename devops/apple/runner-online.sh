#!/bin/sh
# Exits 0 when a macOS runner of this project that is not paused asked GitLab
# for work within the last RUNNER_FRESH_SECONDS seconds (300 by default), and 1
# when none did or GitLab could not be asked. Needs curl and jq, and
# RUNNER_CHECK_TOKEN: a project access token with the read_api scope.

fresh=${RUNNER_FRESH_SECONDS:-300}

if [ -z "$RUNNER_CHECK_TOKEN" ]; then
  echo "RUNNER_CHECK_TOKEN is not set, so the macOS runner cannot be checked"
  exit 1
fi

auth="PRIVATE-TOKEN: $RUNNER_CHECK_TOKEN"
if ! ids=$(curl -sf -H "$auth" "$CI_API_V4_URL/projects/$CI_PROJECT_ID/runners?tag_list=macos&per_page=100" |
  jq -r '.[] | select(.paused | not) | .id'); then
  echo "Could not ask GitLab about the macOS runner"
  exit 1
fi

now=$(date +%s)
for id in $ids; do
  # contacted_at carries a zone offset, which jq's date parser does not read,
  # so the offset is applied by hand.
  seen=$(curl -sf -H "$auth" "$CI_API_V4_URL/runners/$id" | jq -r '
    .contacted_at // ""
    | capture("^(?<t>[0-9-]+T[0-9:]+)(\\.[0-9]+)?(?<z>Z|(?<s>[+-])(?<h>[0-9]{2}):?(?<m>[0-9]{2}))$")
    | (.t + "Z" | fromdateiso8601)
      - (if .z == "Z" then 0
         else ((.h | tonumber) * 3600 + (.m | tonumber) * 60) * (if .s == "+" then 1 else -1 end)
         end)') || seen=""
  [ -n "$seen" ] || continue
  ago=$((now - seen))
  if [ "$ago" -le "$fresh" ]; then
    echo "macOS runner $id was in touch ${ago}s ago"
    exit 0
  fi
  echo "macOS runner $id was last in touch ${ago}s ago"
done

echo "No macOS runner is online"
exit 1
