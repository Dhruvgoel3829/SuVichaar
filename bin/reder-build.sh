#!/usr/binn.env bash# exit on error
set -o errexit

bundle istall
bundle exec rails assets:precompile
bundle exec rails assets:clean