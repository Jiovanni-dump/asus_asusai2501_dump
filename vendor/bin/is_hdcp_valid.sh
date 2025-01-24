#!/vendor/bin/sh

FILE=/mnt/vendor/persist/HDCP.FLG
if [ -f "$FILE" ]; then
    setprop "vendor.atd.hdcp.ready" TRUE
else
    setprop "vendor.atd.hdcp.ready" FALSE
fi

ret=$(/vendor/bin/hdcp2p2prov -verify)
if [ "${ret}" = "Verification succeeded. Device is provisioned." ]; then
	setprop "vendor.atd.hdcp2p2.ready" TRUE
else
	setprop "vendor.atd.hdcp2p2.ready" FALSE
fi

ret=$(/vendor/bin/hdcp1prov -verify)
if [ "${ret}" = "Verification succeeded. Device is provisioned." ]; then
	setprop "vendor.atd.hdcp1.ready" TRUE
else
	setprop "vendor.atd.hdcp1.ready" FALSE
fi

HDCP_READY=$(getprop vendor.atd.hdcp.ready)
HDCP1_READY=$(getprop vendor.atd.hdcp1.ready)
HDCP2P2_READY=$(getprop vendor.atd.hdcp2p2.ready)

# Log result.
log "vendor.atd.hdcp.ready = ${HDCP_READY}"
log "vendor.atd.hdcp1.ready = ${HDCP1_READY}"
log "vendor.atd.hdcp2p2.ready = ${HDCP2P2_READY}"
