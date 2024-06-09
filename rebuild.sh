#!/usr/bin/env bash
sudo nixos-rebuild switch &>nixos-switch.log || ( cat ~/Documents/nix/nixos-switch.log | grep --color error && false)
