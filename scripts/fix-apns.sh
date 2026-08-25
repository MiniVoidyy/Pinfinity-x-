#!/usr/bin/env bash
# Create empty APNs config stub
mkdir -p ~/pinfinity-src/device/sample/etc
cat > ~/pinfinity-src/device/sample/etc/apns-full-conf.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<!-- Stub APN config - flash a full APNs file at runtime -->
<apns>
</apns>
EOF
echo ">> created empty apns-full-conf.xml stub"
