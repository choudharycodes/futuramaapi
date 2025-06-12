#!/bin/bash
echo "Starting Futurama API on Azure App Service..."

# Set working directory
cd /home/site/wwwroot

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Run database migrations if DATABASE_URL is available
if [ ! -z "$DATABASE_URL" ]; then
    echo "Running database migrations..."
    python -m alembic upgrade head || {
        echo "Migration failed, but continuing with startup..."
    }
else
    echo "No DATABASE_URL found, skipping migrations"
fi

# Start the application
echo "Starting Futurama API..."
exec python -m futuramaapi -b :${PORT:-8000}
