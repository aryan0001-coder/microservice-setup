# How to Run and Test API Endpoints

## Step 1: Start All Services

Make sure all services are running:

```bash
cd /home/user/Downloads/nestjs-rest-microservices

# Build and start all services
npm run docker:build
npm run docker:start

# Or use docker-compose directly
docker-compose up -d
```

## Step 2: Verify Services Are Running

Check if all containers are up:

```bash
docker-compose ps
```

You should see:
- ✅ `api-gateway` - Running on port 3000
- ✅ `swagger-ui` - Running on port 8080
- ✅ `comments-svc` - Running
- ✅ `organizations-svc` - Running
- ✅ `users-svc` - Running
- ✅ `postgres-db` - Running on port 5434

## Step 3: Access the API

### Option 1: Swagger UI (Recommended - Easiest Way)

1. Open your browser and go to: **http://localhost:8080**
2. You'll see the Swagger UI with all available endpoints
3. Click on any endpoint to expand it
4. Click "Try it out" to test the endpoint
5. Fill in parameters and click "Execute"

### Option 2: Direct API Calls

Base URL: **http://localhost:3000**

## Available Endpoints

### 1. Health Check
```bash
GET http://localhost:3000/healthz
```

**Response:** `OK`

---

### 2. Get All Organizations
```bash
GET http://localhost:3000/orgs
```

**Query Parameters:**
- `q` (optional) - Search by organization name (e.g., `?q=acme`)
- `page` (optional) - Page number (default: 1)
- `limit` (optional) - Records per page (default: 25)
- `select` (optional) - Fields to return (e.g., `?select=id,name`)
- `orderBy` (optional) - Sort order (e.g., `?orderBy=name,-createdAt`)

**Example:**
```bash
curl http://localhost:3000/orgs
curl http://localhost:3000/orgs?q=acme
curl http://localhost:3000/orgs?page=1&limit=10
```

**Response:**
```json
{
  "totalRecords": 2,
  "totalPages": 1,
  "page": 1,
  "limit": 25,
  "data": [
    {
      "id": "7fe5b86f-b30d-40ee-9b8b-8619edf0fb18",
      "name": "acme",
      "createdAt": "2019-08-05T10:02:18.047Z",
      "updatedAt": "2020-01-05T15:22:03.020Z",
      "version": 2
    }
  ]
}
```

---

### 3. Get Organization Members
```bash
GET http://localhost:3000/orgs/{name}/members
```

**Path Parameters:**
- `name` - Organization name (e.g., `acme`)

**Query Parameters:**
- `q` (optional) - Search by member name
- `page`, `limit`, `select`, `orderBy` - Same as above

**Example:**
```bash
curl http://localhost:3000/orgs/acme/members
curl http://localhost:3000/orgs/acme/members?q=user1&limit=10
```

**Response:**
```json
{
  "totalRecords": 2,
  "totalPages": 1,
  "page": 1,
  "limit": 25,
  "data": [
    {
      "id": "331fe8f5-7c1c-48d2-8890-b1df8a1853a1",
      "organization": "7fe5b86f-b30d-40ee-9b8b-8619edf0fb18",
      "loginId": "user1",
      "avatar": "https://gravatar.com/avatar/...",
      "followers": 2,
      "following": 5,
      "createdAt": "2019-08-05T10:02:18.047Z",
      "updatedAt": "2020-01-05T15:22:03.020Z",
      "version": 2
    }
  ]
}
```

---

### 4. Get Organization Comments
```bash
GET http://localhost:3000/orgs/{name}/comments
```

**Path Parameters:**
- `name` - Organization name

**Query Parameters:**
- `q` (optional) - Search in comment text
- `page`, `limit`, `select`, `orderBy` - Same as above

**Example:**
```bash
curl http://localhost:3000/orgs/acme/comments
curl http://localhost:3000/orgs/acme/comments?q=Lorem
```

**Response:**
```json
{
  "totalRecords": 2,
  "totalPages": 1,
  "page": 1,
  "limit": 25,
  "data": [
    {
      "id": "a64b3121-8d27-43f9-9138-2e4121972720",
      "organization": "7fe5b86f-b30d-40ee-9b8b-8619edf0fb18",
      "comment": "Nulla condimentum ornare nisi...",
      "createdAt": "2019-08-05T10:02:18.047Z",
      "updatedAt": "2020-01-05T15:22:03.020Z",
      "version": 2
    }
  ]
}
```

---

### 5. Create Comment for Organization
```bash
POST http://localhost:3000/orgs/{name}/comments
```

**Path Parameters:**
- `name` - Organization name

**Request Body:**
```json
{
  "comment": "This is a new comment"
}
```

**Example:**
```bash
curl -X POST http://localhost:3000/orgs/acme/comments \
  -H "Content-Type: application/json" \
  -d '{"comment": "This is a great organization!"}'
```

**Response:**
```json
{
  "id": "74d0f515-6b4d-4112-9439-ed10752d0bc9",
  "organization": "7fe5b86f-b30d-40ee-9b8b-8619edf0fb18",
  "comment": "This is a great organization!",
  "createdAt": "2019-08-05T10:02:18.047Z",
  "updatedAt": "2019-08-05T10:02:18.047Z",
  "version": 1
}
```

---

### 6. Delete All Comments for Organization
```bash
DELETE http://localhost:3000/orgs/{name}/comments
```

**Path Parameters:**
- `name` - Organization name

**Example:**
```bash
curl -X DELETE http://localhost:3000/orgs/acme/comments
```

**Response:**
```json
{
  "count": 8
}
```

---

## Testing with Different Tools

### Using cURL

```bash
# Health check
curl http://localhost:3000/healthz

# Get organizations
curl http://localhost:3000/orgs

# Get members
curl http://localhost:3000/orgs/acme/members

# Create comment
curl -X POST http://localhost:3000/orgs/acme/comments \
  -H "Content-Type: application/json" \
  -d '{"comment": "Test comment"}'
```

### Using Postman

1. Create a new request
2. Set method (GET, POST, DELETE)
3. Enter URL: `http://localhost:3000/orgs` (or other endpoint)
4. For POST requests, add JSON body in "Body" tab
5. Click "Send"

### Using Swagger UI (Easiest)

1. Open **http://localhost:8080** in browser
2. All endpoints are listed with documentation
3. Click endpoint → "Try it out" → Fill parameters → "Execute"
4. See response directly in browser

### Using Browser

For GET requests, simply open:
- http://localhost:3000/healthz
- http://localhost:3000/orgs
- http://localhost:3000/orgs/acme/members
- http://localhost:3000/orgs/acme/comments

---

## Troubleshooting

### Services Not Running
```bash
# Check status
docker-compose ps

# View logs
docker-compose logs api-gateway
docker-compose logs organizations-svc
docker-compose logs users-svc
docker-compose logs comments-svc

# Restart services
docker-compose restart
```

### Connection Refused
- Make sure API Gateway is running: `docker-compose ps api-gateway`
- Check if port 3000 is available: `netstat -tlnp | grep 3000`
- Check API Gateway logs: `docker-compose logs api-gateway`

### Empty Results
- Check if database has data: Connect to DBeaver (port 5434) and query tables
- Check microservice logs for errors
- Verify database connection in docker-compose.yaml

### 404 Not Found
- Make sure you're using the correct endpoint path
- Check Swagger UI at http://localhost:8080 for exact paths
- Verify the organization name exists in database

---

## Quick Test Sequence

1. **Health Check:**
   ```bash
   curl http://localhost:3000/healthz
   ```
   Expected: `OK`

2. **List Organizations:**
   ```bash
   curl http://localhost:3000/orgs
   ```

3. **Get Members (replace 'acme' with actual org name):**
   ```bash
   curl http://localhost:3000/orgs/acme/members
   ```

4. **Create Comment:**
   ```bash
   curl -X POST http://localhost:3000/orgs/acme/comments \
     -H "Content-Type: application/json" \
     -d '{"comment": "Hello from API!"}'
   ```

5. **View Comments:**
   ```bash
   curl http://localhost:3000/orgs/acme/comments
   ```
