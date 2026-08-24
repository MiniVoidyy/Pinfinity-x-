#!/usr/bin/env bash
# Mass-checkout all projects to their manifest revisions,
# bypassing repo's flaky checkout step.
cd "$HOME/pinfinity-src" || exit 1
export PATH="$HOME/bin:$PATH"
rm -f /tmp/checkout-fails.txt

echo ">> checking out all projects (this can take a while)..."
repo forall -j8 -c '
  if ! git checkout -f "$REPO_RREV" >/dev/null 2>&1; then
    echo "$REPO_PATH $REPO_RREV" >> /tmp/checkout-fails.txt
  fi
'

echo ">> done."
if [ -s /tmp/checkout-fails.txt ]; then
  echo "FAILURES:"
  head -20 /tmp/checkout-fails.txt
else
  echo "ALL_PROJECTS_CHECKED_OUT"
fi
