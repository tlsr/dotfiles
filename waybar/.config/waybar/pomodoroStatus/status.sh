#!/bin/bash

timeLeft=$(pomodoro status --format "%!r 🍅")
tooltip=$(pomodoro status --format "%d")
echo "{\"text\": \"$timeLeft\", \"alt\": \"alt\", \"tooltip\": \"${tooltip}\"}"

