#!/bin/bash

lovebrew build
nxlink --port 11111 --address localhost build/*.nro
