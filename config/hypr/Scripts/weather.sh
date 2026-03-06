#!/bin/bash

city=$(curl -s https://ipinfo.io/city)

# fallback if lookup fails
[ -z "$city" ] && city="Ho Chi Minh"

weather=$(curl -s "https://wttr.in/${city// /+}?format=%c+%t+%l")

echo "$weather" | sed 's/+/\ /g' | sed 's/%//'
