#!/bin/bash

brightnessctl -s
curr=$(brightnessctl g)
dimmed=$((curr * 25 / 100))
brightnessctl set "$dimmed"
