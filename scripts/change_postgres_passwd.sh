#!/bin/bash

sudo -u postgres psql postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';
