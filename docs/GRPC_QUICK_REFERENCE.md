# gRPC Quick Reference Guide

## Cheat Sheet for Developers

---

## Protocol Buffer Syntax

### Basic Message
```protobuf
message User {
  string id = 1;
  string name = 2;
  int32 age = 3;
  bool active = 4;
}
```

### Service Definition
```protobuf
service UserService {
  rpc GetUser (UserRequest) returns (User) {}
  rpc ListUsers (Empty) returns (UserList) {}
}
```

### Common Field Types
- `string` - Text data
- `int32`, `int64` - Integers
- `float`, `double` - Floating point
- `bool` - Boolean
- `bytes` - Binary data
- `repeated` - Arrays/lists

---

## NestJS gRPC Setup

### Server (Microservice)
```typescript
// main.ts
const app = await NestFactory.createMicroservice(AppModule, {
  transport: Transport.GRPC,
  options: {
    url: '0.0.0.0:50051',
    package: 'users',
    protoPath: join(__dirname, './_proto/users.proto'),
  }
})
```

### Client (API Gateway)
```typescript
// svc.options.ts
export const UserServiceClientOptions: ClientOptions = {
  transport: Transport.GRPC,
  options: {
    url: 'users-svc:50051',
    package: 'users',
    protoPath: join(__dirname, '../_proto/users.proto'),
  }
}

// controller.ts
@Client(UserServiceClientOptions)
private readonly userClient: ClientGrpc

private userService: UserService

onModuleInit() {
  this.userService = this.userClient.getService<UserService>('UserService')
}
```

### Controller Method
```typescript
@GrpcMethod('UserService', 'GetUser')
async getUser(data: UserRequest): Promise<User> {
  return await this.userService.findOne(data.id)
}
```

### Client Call
```typescript
const user = await this.userService.getUser({ id: '123' }).toPromise()
```

---

## gRPC Status Codes

| Code | Name | HTTP Equivalent | Use Case |
|------|------|-----------------|----------|
| 0 | OK | 200 | Success |
| 3 | INVALID_ARGUMENT | 400 | Bad request |
| 5 | NOT_FOUND | 404 | Resource not found |
| 7 | PERMISSION_DENIED | 403 | Unauthorized |
| 13 | INTERNAL | 500 | Server error |
| 14 | UNAVAILABLE | 503 | Service unavailable |
| 16 | UNAUTHENTICATED | 401 | Authentication failed |

### Error Handling
```typescript
import { RpcException } from '@nestjs/microservices'
import { status } from '@grpc/grpc-js'

throw new RpcException({
  code: status.NOT_FOUND,
  message: 'User not found'
})
```

---

## Common Patterns

### Query with Filters
```typescript
// Proto
message Query {
  string where = 1;  // JSON string
  string order = 2;  // JSON string
  int32 offset = 3;
  int32 limit = 4;
}

// Server
@GrpcMethod('Service', 'findAll')
async findAll(query: Query) {
  const where = JSON.parse(query.where || '{}')
  return await this.repo.findAll({ where })
}

// Client
const result = await this.service.findAll({
  where: JSON.stringify({ organization: orgId }),
  limit: 25
}).toPromise()
```

### Pagination
```typescript
// Proto
message PaginatedResponse {
  repeated Item data = 1;
  int32 total = 2;
  int32 page = 3;
  int32 limit = 4;
}
```

---

## Debugging Tips

### Enable gRPC Logging
```typescript
// In main.ts
process.env.GRPC_VERBOSITY = 'DEBUG'
process.env.GRPC_TRACE = 'all'
```

### View gRPC Calls
```bash
# Docker logs
docker-compose logs -f api-gateway | grep gRPC

# Specific service
docker-compose logs organizations-svc
```

### Test gRPC Directly
```bash
# Install grpcurl
brew install grpcurl  # Mac
# or download from https://github.com/fullstorydev/grpcurl

# List services
grpcurl -plaintext localhost:50051 list

# Call method
grpcurl -plaintext -d '{"name":"acme"}' \
  localhost:50051 organizations.OrganizationsService/findByName
```

---

## Performance Tips

### 1. Enable Compression
```typescript
options: {
  // ... other options
  channelOptions: {
    'grpc.default_compression_algorithm': 2, // GZIP
  }
}
```

### 2. Connection Pooling
```typescript
// Reuse client instances
// Don't create new client for each request
```

### 3. Use Streaming for Large Data
```protobuf
service DataService {
  rpc GetLargeData (Request) returns (stream Item) {}
}
```

---

## Common Issues & Solutions

### Issue: "14 UNAVAILABLE: DNS resolution failed"
**Solution:** Check service name in docker-compose network

### Issue: "The 'grpc' package is missing"
**Solution:** Install build dependencies in Dockerfile:
```dockerfile
RUN apk add --no-cache python3 make g++ python3-dev
```

### Issue: "Invalid value { '$like': 'value' }"
**Solution:** Use `$iLike` for PostgreSQL or `Op.like` from Sequelize

### Issue: Proto file not found
**Solution:** Ensure proto files are copied to dist folder during build

---

## File Structure Checklist

```
✅ _proto/
   ✅ comments.proto
   ✅ organizations.proto
   ✅ users.proto
   ✅ commons.proto

✅ api-gateway/src/
   ✅ _proto/ (copied proto files)
   ✅ comments/comments-svc.options.ts
   ✅ organizations/organization-svc.options.ts
   ✅ users/users-svc.options.ts

✅ microservices/*/src/
   ✅ _proto/ (copied proto files)
   ✅ main.ts (gRPC server setup)
   ✅ */*.controller.ts (gRPC methods)
```

---

## Testing Commands

### Health Check
```bash
curl http://localhost:3000/healthz
```

### Get Organizations
```bash
curl http://localhost:3000/orgs
```

### Get Members
```bash
curl http://localhost:3000/orgs/Schneider---Carter/members
```

### Create Comment
```bash
curl -X POST http://localhost:3000/orgs/acme/comments \
  -H "Content-Type: application/json" \
  -d '{"comment": "Test comment"}'
```

---

## Useful Links

- [gRPC Documentation](https://grpc.io/docs/)
- [Protocol Buffers Guide](https://developers.google.com/protocol-buffers/docs/overview)
- [NestJS Microservices](https://docs.nestjs.com/microservices/basics)
- [grpcurl Tool](https://github.com/fullstorydev/grpcurl)

---

**Quick Tip:** Always check Docker logs when debugging gRPC issues!
