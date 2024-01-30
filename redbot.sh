#!/usr/bin/env sh
set -e

# Install pip packages
if [ -n "$PIP_REQUIREMENTS" ]; then
    pip install --no-cache-dir $PIP_REQUIREMENTS
fi

# Check if a Red instance exists
echo 'Checking for existing Red instances...'

if redbot --list-instances | grep -qe '^No instances have been configured!'; then
    echo "No Red instance found. Creating instance '$INSTANCE_NAME'..."

    {
        redbot-setup --instance-name "$INSTANCE_NAME" --no-prompt --data-path /redbot/data && \
        echo "Red instance '$INSTANCE_NAME' created successfully."
    } || {
        echo "Failed to create Red instance '$INSTANCE_NAME'."
        exit 1
    }
fi

ARGS="$INSTANCE_NAME --token $TOKEN --prefix $PREFIX --no-prompt"

if [ "$RPC_ENABLED" = 'true' ]; then
    ARGS="$ARGS --rpc"

    if [ -z "$RPC_PORT" ]; then
        ARGS="$ARGS --rpc-port 6133"
    else
        ARGS="$ARGS --rpc-port $RPC_PORT"
    fi
fi

if [ "$TEAM_MEMBERS_ARE_OWNERS" = 'true' ]; then
    ARGS="$ARGS --team-members-are-owners"
fi

if [ -n "$EXTRA_ARGS" ]; then
    ARGS="$ARGS $EXTRA_ARGS"
fi

# Start Red
echo 'Starting Red...'
redbot $ARGS
