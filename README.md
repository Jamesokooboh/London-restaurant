# 3-Tier London Restaurant Web App (Docker CLI)

This project is a 3-tier web application (Frontend, Backend, Database) running entirely on Docker using native Docker CLI commands (no Docker Compose). 

The application features a styled London restaurant menu served by an Nginx frontend, which proxies API requests to a Node.js/Express backend, which in turn fetches data from a PostgreSQL database.

## Architecture
* **Frontend:** Nginx serving static HTML/CSS/JS.
* **Backend:** Node.js with Express for the API.
* **Database:** PostgreSQL (with a persistent volume and initial seed data).
* **Networking:** All containers communicate securely over a shared Docker bridge network.

## Prerequisites
* [Docker](https://docs.docker.com/get-docker/) installed and running on your machine.
* A terminal or command prompt.

## Project Structure
Before running the commands, ensure your project directory looks exactly like this:

```text
london-restaurant/
├── README.md
├── init.sql
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
└── frontend/
    ├── Dockerfile
    ├── nginx.conf
    └── index.html
```

---

## Step-by-Step Setup Guide

Open your terminal, navigate to the root `london-restaurant` directory, and run the following steps in order.

### Step 1: Create the Network and Storage Volume
Containers need to be on the same network to resolve each other by name. The volume ensures your database data isn't lost if the database container restarts or is deleted.

```bash
docker network create london_net
docker volume create db_data
```

### Step 2: Start the Database Tier
This command starts PostgreSQL, attaches it to the network, sets the credentials, and mounts the `init.sql` script so the database is automatically populated with our menu on the first run.

**Mac/Linux:**
```bash
docker run -d \
  --name db \
  --network london_net \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=restaurant \
  -v db_data:/var/lib/postgresql/data \
  -v "$(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql" \
  postgres:15-alpine
```

**Windows (Command Prompt):**
Replace `$(pwd)` with `%cd%`:
```cmd
docker run -d --name db --network london_net -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=password -e POSTGRES_DB=restaurant -v db_data:/var/lib/postgresql/data -v "%cd%/init.sql:/docker-entrypoint-initdb.d/init.sql" postgres:15-alpine
```

### Step 3: Build and Start the Backend Tier
Next, we build the Node.js API and pass the database credentials as environment variables so it knows how to connect to the `db` container.

```bash
# 1. Build the image
docker build -t london-backend ./backend

# 2. Run the container
docker run -d \
  --name backend \
  --network london_net \
  -e DB_HOST=db \
  -e DB_USER=admin \
  -e DB_PASSWORD=password \
  -e DB_NAME=restaurant \
  -e PORT=5000 \
  -p 5000:5000 \
  london-backend
```

### Step 4: Build and Start the Frontend Tier
Finally, build the Nginx web server. The Nginx configuration automatically proxies any requests sent to `/api/` over to the backend container.

```bash
# 1. Build the image
docker build -t london-frontend ./frontend

# 2. Run the container
docker run -d \
  --name frontend \
  --network london_net \
  -p 80:80 \
  london-frontend
```

---

## Viewing the Application
Once all three containers are running, open your web browser and navigate to:
👉 **http://localhost**

You should see "The Thames Tavern" page, and it will fetch the live menu items directly from the database!

## Useful Management Commands

**Check the status of your containers:**
```bash
docker ps
```

**View logs (helpful if something isn't working):**
```bash
docker logs backend
docker logs db
```

**Stop the application:**
```bash
docker stop frontend backend db
```

**Clean up (removes containers but keeps your database data volume):**
```bash
docker rm frontend backend db
```

**Full Teardown (Warning: This deletes the database data and network too):**
```bash
docker rm -f frontend backend db
docker network rm london_net
docker volume rm db_data
```