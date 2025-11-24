# ============================================================
#  Mijn.host Dynamic DNS Updater for MikroTik RouterOS
#  Author: Maikel Wijnen
#  Version: 1.0
#  Description:
#      Automatically updates a Mijn.host DNS A-record with
#      the router's current public IP.
# ============================================================

# -------------------------
# USER CONFIGURATION
# -------------------------
:local apiKey "CHANGE_ME"                      # Your Mijn.host API key
:local domain "CHANGE_ME"                      # Example: "domain.com"
:local subdomains {"vpn"}                      # Example: {"vpn";"home"}
:local ttl "900"                               # TTL in seconds
# -------------------------
# END USER CONFIGURATION
# -------------------------

# Create main DDNS script
/system script add name="mijnhost-ddns" policy=read,write,policy,test,net source={

    :local apiKey "$apiKey"
    :local domain "$domain"
    :local subdomains $subdomains
    :local ttl "$ttl"

    :local logPrefix "mijnhost-ddns:"

    # Fetch public IP
    :global currentIP
    :local newIP ([/tool fetch url="https://api.ipify.org" mode=https output=user as-value]->"data")

    # Basic check
    :if ($newIP = "" || $newIP = nil) do={
        :log warning "$logPrefix Failed to obtain public IP"
        :return
    }

    # If unchanged → skip
    :if ($currentIP = $newIP) do={
        :log info "$logPrefix No change in IP ($newIP)"
        :return
    }

    :log info "$logPrefix Public IP changed to $newIP"

    # Loop through subdomains
    :foreach sub in=$subdomains do={

        :local fqdn "$sub.$domain"

        /tool fetch http-method=put \
            url=("https://api.mijn.host/dns/v2/$domain/records/$sub") \
            http-header-field="Authorization: Bearer $apiKey" \
            http-data=("{
                \"type\": \"A\",
                \"hostname\": \"$sub\",
                \"value\": \"$newIP\",
                \"ttl\": $ttl
            }") \
            output=none

        :log info "$logPrefix Updated A-record: $fqdn → $newIP"
    }

    :set currentIP $newIP
}

# Create scheduler entry
/system scheduler add name="mijnhost-ddns" \
    interval=5m \
    on-event="/system script run mijnhost-ddns" \
    policy=read,policy,test,net

# Installation complete
:log info "mijnhost-ddns: Installation completed successfully"
