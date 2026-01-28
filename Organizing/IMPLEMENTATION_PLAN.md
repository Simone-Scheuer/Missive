# Missive - Implementation Plan
## Backend API Implementation Based on Course Specifications

## Overview
This plan outlines the implementation strategy for Missive's backend, focusing on **minimum viable functionality** that meets the CS 314 course API requirements while remaining **maximally flexible** to support the magical, immersive UI vision described in the project specifications.

**Key Principle**: The backend is a pure data layer - it doesn't care about runes, animations, or visual effects. It just handles authentication, user data, contacts, and messages. The frontend can implement any UI/UX on top of this foundation.

---

## Technology Stack (MERN)

### Required Stack
- **MongoDB**: Database for storing users, messages, and contacts
- **Express**: Web framework for REST API
- **React**: Frontend framework (for reference/testing)
- **Node.js**: Runtime environment

### Additional Technologies
- **Socket.IO**: Real-time messaging via WebSockets
- **JWT (jsonwebtoken)**: Authentication tokens
- **bcrypt**: Password hashing
- **cookie-parser**: HTTP-only cookie management
- **CORS**: Cross-origin resource sharing
- **Ngrok**: Backend deployment (for course requirements)

---

## Backend API Endpoints (As Specified)

### Authentication Routes (`/api/auth`)

#### 1. POST `/api/auth/signup`
**Purpose**: User registration

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response (201 Created)**:
```json
{
  "user": {
    "id": "123456",
    "email": "user@example.com",
    "firstName": "",
    "lastName": "",
    "image": "",
    "profileSetup": false
  }
}
```

**Error Responses**:
- `400 Bad Request`: Missing email or password
- `409 Conflict`: Email already in use
- `500 Internal Server Error`: Server/database issue

**Implementation Notes**:
- Hash password with bcrypt before storing
- Generate unique user ID (MongoDB ObjectId)
- Set HTTP-only JWT cookie
- Initialize user with empty profile fields

---

#### 2. POST `/api/auth/login`
**Purpose**: User authentication

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response (200 OK)**:
```json
{
  "user": {
    "id": "123456",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "image": "profile.jpg",
    "profileSetup": true
  }
}
```

**Error Responses**:
- `400 Bad Request`: Missing email/password or invalid password
- `404 Not Found`: No user found with email
- `500 Internal Server Error`: Server/database issue

**Implementation Notes**:
- Verify password with bcrypt
- Set HTTP-only JWT cookie on success
- Return full user object

---

#### 3. POST `/api/auth/logout`
**Purpose**: User logout

**Request Body**: None required

**Response (200 OK)**:
```json
{
  "success": true
}
```

**Implementation Notes**:
- Clear HTTP-only JWT cookie
- Optionally invalidate token on server side

---

#### 4. GET `/api/auth/userinfo`
**Purpose**: Get current user information

**Request Body**: None required
**Authentication**: Required (JWT cookie)

**Response (200 OK)**:
```json
{
  "id": "123456",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "image": "profile.jpg",
  "profileSetup": false,
  "color": "#ff5733"
}
```

**Error Responses**:
- `404 Not Found`: User ID not in token or user doesn't exist
- `500 Internal Server Error`: Unexpected server error

**Implementation Notes**:
- Extract user ID from JWT token
- Query database for user
- Return user object

---

#### 5. POST `/api/auth/update-profile`
**Purpose**: Update user profile information

**Request Body**:
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "color": "#ff5733"
}
```

**Response (200 OK)**:
```json
{
  "id": "123456",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "image": "profile.jpg",
  "profileSetup": true,
  "color": "#ff5733"
}
```

**Error Responses**:
- `400 Bad Request`: Missing user ID or required fields
- `500 Internal Server Error`: Unexpected server error

**Implementation Notes**:
- Update firstName, lastName, color fields
- Set `profileSetup: true` after first update
- Return updated user object

---

### Contact Routes (`/api/contacts`)

#### 6. POST `/api/contacts/search`
**Purpose**: Search for users by keyword

**Request Body**:
```json
{
  "searchTerm": "john"
}
```

**Response (200 OK)**:
```json
{
  "contacts": [
    {
      "_id": "123456",
      "firstName": "John",
      "lastName": "Doe",
      "email": "user@example.com"
    }
  ]
}
```

**Error Responses**:
- `400 Bad Request`: Missing searchTerm
- `500 Internal Server Error`: Unexpected server error

**Implementation Notes**:
- Search firstName, lastName, and email fields
- Exclude current user from results
- Return array of matching users

---

#### 7. GET `/api/contacts/all-contacts`
**Purpose**: Get all users except current user

**Request Body**: None required
**Authentication**: Required

**Response (200 OK)**:
```json
{
  "contacts": [
    {
      "label": "John Doe",
      "value": "123456"
    }
  ]
}
```

**Implementation Notes**:
- Return all users except authenticated user
- Format as `{label: "Full Name", value: "userId"}` for dropdown compatibility
- Sort alphabetically by name

---

#### 8. GET `/api/contacts/get-contacts-for-list`
**Purpose**: Get contacts sorted by last message time

**Request Body**: None required
**Authentication**: Required

**Response (200 OK)**:
```json
{
  "contacts": [
    {
      "_id": "123456",
      "firstName": "John",
      "lastName": "Doe",
      "email": "user@example.com",
      "image": "profile1.jpg",
      "color": "#ffcc00",
      "lastMessageTime": "2025-03-07T12:30:00.000Z"
    }
  ]
}
```

**Error Responses**:
- `400 Bad Request`: No user ID in token
- `500 Internal Server Error`: Server/database error

**Implementation Notes**:
- Get all users the current user has exchanged messages with
- Sort by `lastMessageTime` (most recent first)
- Include user details and last message timestamp
- This is used for the home screen contact list

---

#### 9. DELETE `/api/contacts/delete-dm/:dmId`
**Purpose**: Delete all direct messages with a specific user

**URL Parameter**: `dmId` (string, required) - ID of the other user

**Request Body**: None required
**Authentication**: Required

**Response (200 OK)**:
```json
{
  "message": "DM deleted successfully"
}
```

**Error Responses**:
- `400 Bad Request`: Missing or invalid dmId
- `500 Internal Server Error`: Server/database error

**Implementation Notes**:
- Delete all messages between current user and `dmId`
- Optionally remove contact relationship
- Return success message

---

### Message Routes (`/api/messages`)

#### 10. POST `/api/messages/get-messages`
**Purpose**: Get message history with a specific user

**Request Body**:
```json
{
  "id": "78910"
}
```

**Response (200 OK)**:
```json
{
  "messages": [
    {
      "_id": "msg123",
      "sender": "123456",
      "recipient": "78910",
      "content": "Hey, how are you?",
      "timestamp": "2025-03-07T12:30:00.000Z"
    }
  ]
}
```

**Error Responses**:
- `400 Bad Request`: Missing one or both user IDs
- `500 Internal Server Error`: Server/database error

**Implementation Notes**:
- Get all messages between current user and specified contact
- Sort by timestamp (oldest first)
- Return array of message objects

---

### Socket.IO Events (Real-time Messaging)

#### Connection Setup
- **URL**: Connect to backend server URL
- **Authentication**: JWT token in cookie (automatic with `withCredentials: true`)
- **Headers**: `"ngrok-skip-browser-warning": "true"` (for Ngrok deployment)

#### Event: `sendMessage` (Client → Server)
**Purpose**: Send a direct message

**Payload**:
```json
{
  "sender": "123456",
  "recipient": "78910",
  "content": "Hello!",
  "messageType": "text"
}
```

**Server Action**:
1. Validate sender and recipient
2. Save message to database
3. Emit `receiveMessage` to both sender and recipient

---

#### Event: `receiveMessage` (Server → Client)
**Purpose**: Receive a new message in real-time

**Payload**:
```json
{
  "id": "msg123",
  "sender": {
    "_id": "123456",
    "firstName": "John",
    "lastName": "Doe"
  },
  "recipient": {
    "_id": "78910",
    "firstName": "Jane",
    "lastName": "Smith"
  },
  "content": "Hello!",
  "messageType": "text",
  "timestamp": "2025-03-07T12:30:00.000Z"
}
```

**Client Action**:
- Update UI with new message
- Both sender and recipient receive this event

---

## Database Schema (MongoDB)

### Users Collection
```javascript
{
  _id: ObjectId,
  email: String (unique, required),
  password: String (hashed, required),
  firstName: String,
  lastName: String,
  image: String, // URL or path to profile picture
  profileSetup: Boolean (default: false),
  color: String, // Hex color code for UI theming
  runeSequence: String, // 6-letter code (A-Z) for rune system
  createdAt: Date,
  updatedAt: Date
}
```

**Indexes**:
- `email`: Unique index
- `runeSequence`: Index for rune-based user lookup

---

### Messages Collection
```javascript
{
  _id: ObjectId,
  sender: ObjectId (ref: Users),
  recipient: ObjectId (ref: Users),
  content: String, // Text content, JSON for drawings, URL for voice
  messageType: String, // "text", "drawing", "voice"
  timestamp: Date (default: Date.now),
  readBy: [ObjectId], // Array of user IDs who have read this
  metadata: Object // Flexible storage for UI-specific data
}
```

**Indexes**:
- `sender`: Index
- `recipient`: Index
- `timestamp`: Index (for sorting)
- Compound index: `{sender: 1, recipient: 1, timestamp: -1}`

---

### Contacts/Direct Messages (Derived)
**Note**: Contacts are derived from message history, not stored separately. Use `get-contacts-for-list` endpoint to get users with message history.

**Alternative**: If needed, create a `contacts` collection:
```javascript
{
  _id: ObjectId,
  user1: ObjectId (ref: Users),
  user2: ObjectId (ref: Users),
  lastMessageTime: Date,
  createdAt: Date
}
```

---

## Implementation Structure

```
backend/
├── src/
│   ├── config/
│   │   ├── database.js          # MongoDB connection
│   │   ├── jwt.js               # JWT configuration
│   │   └── socket.js            # Socket.IO setup
│   ├── models/
│   │   ├── User.js              # User model/schema
│   │   └── Message.js           # Message model/schema
│   ├── routes/
│   │   ├── auth.js              # /api/auth routes
│   │   ├── contacts.js          # /api/contacts routes
│   │   └── messages.js          # /api/messages routes
│   ├── middleware/
│   │   ├── auth.js              # JWT verification middleware
│   │   ├── errorHandler.js     # Error handling
│   │   └── cors.js              # CORS configuration
│   ├── services/
│   │   ├── runeGenerator.js    # Generate 6-letter rune sequences
│   │   └── socketHandlers.js    # Socket.IO event handlers
│   └── server.js                # Express app setup
├── tests/
│   ├── auth.test.js
│   ├── contacts.test.js
│   └── messages.test.js
├── .env                         # Environment variables
├── package.json
└── README.md
```

---

## Implementation Phases

### Phase 1: Foundation Setup (Week 1)
**Goal**: Get basic server running with database connection

**Tasks**:
1. Initialize Node.js project with Express
2. Set up MongoDB connection
3. Configure environment variables (.env)
4. Set up CORS and middleware
5. Create basic server.js with health check endpoint
6. Test database connection

**Deliverables**:
- Server running on localhost
- MongoDB connected
- Basic project structure

---

### Phase 2: Authentication (Week 1-2)
**Goal**: Implement all authentication endpoints

**Tasks**:
1. Create User model/schema
2. Implement password hashing (bcrypt)
3. Implement JWT token generation and verification
4. Create `/api/auth/signup` endpoint
5. Create `/api/auth/login` endpoint
6. Create `/api/auth/logout` endpoint
7. Create `/api/auth/userinfo` endpoint
8. Create `/api/auth/update-profile` endpoint
9. Create authentication middleware
10. Test all auth endpoints with Postman/curl

**Deliverables**:
- All auth endpoints functional
- JWT cookies working
- User registration and login tested

---

### Phase 3: Contacts & User Management (Week 2)
**Goal**: Implement contact search and management

**Tasks**:
1. Implement `/api/contacts/search` endpoint
2. Implement `/api/contacts/all-contacts` endpoint
3. Implement `/api/contacts/get-contacts-for-list` endpoint
   - Query messages to find contacts
   - Sort by last message time
4. Implement `/api/contacts/delete-dm/:dmId` endpoint
5. Add rune sequence generation service
6. Test all contact endpoints

**Deliverables**:
- Contact search working
- Contact list sorted by activity
- DM deletion working

---

### Phase 4: Messages (Week 2-3)
**Goal**: Implement message storage and retrieval

**Tasks**:
1. Create Message model/schema
2. Implement `/api/messages/get-messages` endpoint
3. Test message retrieval
4. Add message pagination (optional, for performance)

**Deliverables**:
- Message history retrieval working
- Messages stored correctly in database

---

### Phase 5: Real-time Messaging (Week 3)
**Goal**: Implement Socket.IO for real-time message delivery

**Tasks**:
1. Set up Socket.IO server
2. Implement JWT authentication for Socket.IO connections
3. Map user IDs to socket connections
4. Implement `sendMessage` event handler
   - Save message to database
   - Emit `receiveMessage` to sender and recipient
5. Test real-time messaging with multiple clients
6. Handle connection/disconnection events

**Deliverables**:
- Real-time messaging working
- Messages delivered instantly to both users
- Connection management working

---

### Phase 6: Testing & Integration (Week 3-4)
**Goal**: Test backend with frontend and fix issues

**Tasks**:
1. Set up Ngrok for backend deployment
2. Configure frontend to connect to backend
3. Test all endpoints with frontend
4. Test Socket.IO with frontend
5. Fix CORS and cookie issues
6. Add error handling and validation
7. Write unit tests for critical functions
8. Test edge cases and error scenarios

**Deliverables**:
- Backend deployed via Ngrok
- Frontend successfully integrated
- All features working end-to-end
- Error handling robust

---

## Key Implementation Details

### JWT Authentication
```javascript
// Generate token on login/signup
const token = jwt.sign(
  { userId: user._id },
  process.env.JWT_SECRET,
  { expiresIn: '7d' }
);

// Set HTTP-only cookie
res.cookie('token', token, {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: 'strict',
  maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
});

// Verify token middleware
const verifyToken = (req, res, next) => {
  const token = req.cookies.token;
  if (!token) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};
```

### Socket.IO Authentication
```javascript
// Authenticate socket connection
io.use((socket, next) => {
  const token = socket.handshake.auth.token || 
                socket.handshake.headers.cookie?.split('token=')[1]?.split(';')[0];
  
  if (!token) {
    return next(new Error('Authentication error'));
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    socket.userId = decoded.userId;
    next();
  } catch (error) {
    next(new Error('Authentication error'));
  }
});

// Map userId to socket
const userSockets = new Map();

io.on('connection', (socket) => {
  userSockets.set(socket.userId, socket.id);
  
  socket.on('disconnect', () => {
    userSockets.delete(socket.userId);
  });
});
```

### Rune Sequence Generation
```javascript
// Generate unique 6-letter rune sequence (A-Z)
const generateRuneSequence = () => {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  let sequence = '';
  for (let i = 0; i < 6; i++) {
    sequence += letters[Math.floor(Math.random() * letters.length)];
  }
  return sequence;
};

// Check if sequence is unique (optional, for true uniqueness)
const isRuneSequenceUnique = async (sequence) => {
  const existing = await User.findOne({ runeSequence: sequence });
  return !existing;
};
```

### Message Storage for Drawings/Voice
```javascript
// For drawing messages
{
  sender: ObjectId,
  recipient: ObjectId,
  content: JSON.stringify(drawingData), // SVG paths, coordinates, etc.
  messageType: "drawing",
  metadata: {
    color: "#ff5733",
    brushSize: 5,
    canvasWidth: 800,
    canvasHeight: 600
  }
}

// For voice messages
{
  sender: ObjectId,
  recipient: ObjectId,
  content: "/uploads/voice/audio123.mp3", // URL to audio file
  messageType: "voice",
  metadata: {
    duration: 15.5, // seconds
    format: "mp3"
  }
}
```

---

## Frontend Integration Notes

### Axios Configuration
```javascript
import axios from "axios";

const SERVER_URL = "https://pretorial-portliest-vertie.ngrok-free.dev";

const apiClient = axios.create({
  baseURL: SERVER_URL,
  withCredentials: true,
  headers: {
    "ngrok-skip-browser-warning": "true",
  },
});
```

### Socket.IO Configuration
```javascript
import { io } from "socket.io-client";

const socket = io(SERVER_URL, {
  withCredentials: true,
  extraHeaders: {
    "ngrok-skip-browser-warning": "true",
  },
});

socket.on("receiveMessage", (message) => {
  // Update UI with new message
  updateMessageList(message);
});
```

---

## Flexibility Considerations

### 1. Message Types
- Backend stores `messageType` as string - frontend can add new types
- `metadata` field allows UI-specific data without schema changes
- Content field is flexible (text, JSON, URL)

### 2. User Profile
- `color` field for UI theming
- `runeSequence` stored as string - frontend handles visualization
- `image` can be URL, path, or base64 (frontend's choice)

### 3. Extensibility
- Easy to add new fields to User/Message schemas
- Metadata fields support UI-specific features
- Socket.IO events can be extended without breaking changes

### 4. Future Features (Not Required for MVP)
- Time delays: Add `deliveredAt` field to messages
- Group chats: Add `roomId` field, create rooms collection
- Character switching: Add `characters` array to User model
- Read receipts: Use `readBy` array in messages

---

## Error Handling

### Standard Error Response Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {}
  }
}
```

### Common Error Codes
- `AUTH_REQUIRED`: Authentication required
- `INVALID_CREDENTIALS`: Wrong email/password
- `USER_NOT_FOUND`: User doesn't exist
- `MISSING_FIELD`: Required field missing
- `DUPLICATE_EMAIL`: Email already in use
- `SERVER_ERROR`: Internal server error

---

## Testing Strategy

### Unit Tests
- Password hashing/verification
- JWT token generation/verification
- Rune sequence generation
- Database queries

### Integration Tests
- Authentication flow (signup → login → userinfo)
- Contact search and retrieval
- Message sending and retrieval
- Socket.IO message delivery

### Manual Testing
- Use Postman/curl for REST endpoints
- Use Socket.IO client for WebSocket testing
- Test with frontend integration

---

## Deployment Checklist

### Development
- [ ] MongoDB running locally or via MongoDB Atlas
- [ ] Backend server running on localhost:3000 (or specified port)
- [ ] Environment variables configured (.env file)
- [ ] CORS configured for frontend origin

### Production (Ngrok)
- [ ] Ngrok tunnel configured
- [ ] Backend accessible via Ngrok URL
- [ ] Frontend configured to use Ngrok URL
- [ ] `ngrok-skip-browser-warning` header working
- [ ] Cookies working across origins (withCredentials)

---

## Success Criteria

### Minimum Viable Backend
- ✅ All 10 REST API endpoints functional
- ✅ Socket.IO real-time messaging working
- ✅ JWT authentication with HTTP-only cookies
- ✅ MongoDB database storing all data correctly
- ✅ Error handling for all edge cases
- ✅ Frontend can successfully integrate

### Flexibility Success
- ✅ Backend doesn't care about UI implementation
- ✅ Easy to add new message types
- ✅ Metadata fields support UI features
- ✅ API can evolve without breaking changes

---

## Next Steps

1. **Set Up Development Environment**
   - Install Node.js, MongoDB
   - Initialize project with npm
   - Set up Git repository

2. **Implement Phase 1: Foundation**
   - Create project structure
   - Set up Express server
   - Connect to MongoDB

3. **Implement Phase 2: Authentication**
   - Start with signup/login
   - Add JWT and cookies
   - Test with Postman

4. **Continue Through Phases**
   - Follow implementation phases sequentially
   - Test each phase before moving on
   - Integrate with frontend as soon as possible

5. **Deploy and Test**
   - Set up Ngrok
   - Test with frontend
   - Fix integration issues

---

**Note**: This plan focuses on meeting the course API requirements while providing maximum flexibility for the magical UI/UX vision. The backend is intentionally UI-agnostic, allowing the frontend team to implement runes, animations, gestures, and all immersive features without backend changes.
