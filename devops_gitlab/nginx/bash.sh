#!/bin/bash

nginx -s reload
nginx -g 'daemon off;'
