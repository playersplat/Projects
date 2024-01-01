#!/bin/sh

# Check if FORWARDING_ADDRESS is set
if [ -n "$FORWARDING_ADDRESS" ]; then
    # FORWARDING_ADDRESS is set, start forward_instance.py
    python3 /app/forward_instance.py
else
    # No FORWARDING_ADDRESS set, start assignment2.py
    echo "FORWARDING_ADDRESS is not set. Starting assignment2.py..."
    python3 /app/assignment2.py
fi
